Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29ELiah236790 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 08:21:44 -0600
Message-ID: <4F59E78A.7060903@oracle.com>
Date: Fri, 09 Mar 2012 19:20:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH v1 0/4] cgroup quota
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: cgroups@vger.kernel.org
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, tytso@MIT.EDU, Chris Mason <chris.mason@oracle.com>

Hello,

Disk quota feature has been asked at LXC list from time to time.
Given that the project quota has already implemented in XFS for a long time, and it was also in progress for EXT4.
So the major idea is to assign one or more project IDs(or tree ID?) to container, but leaving quota setup via cgroup
config files, so all the tasks running at container could have project quota constraints applied.

I'd like to post an initial patch sets here, the stupid implements is very simple and even crash me
in some cases, sorry! But I would like to submit it to get more feedback to make sure I am going down
the right road. :)

Let me introduce it now.

1. Setup project quota on XFS(enabled pquota) firstly.
For example, the "project100" is configured on "/xfs/quota_test" directory.

$ cat /etc/projects
100:/xfs/quota_test

$ cat /etc/projid
project100:100

$ sudo xfs_quota -x -c 'report -p'
Project quota on /xfs (/dev/sda7)
                               Blocks                     
Project ID       Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
project100          0          0          0     00 [--------]

2. Mount cgroup on /cgroup.
cgroup on /cgroup type cgroup (rw)

After that, there will have a couple of quota.XXXX files presented at /cgroup.
$ ls -l /cgroup/quota.*
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.activate
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.add_project
-r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.all
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.block_limit_in_bytes
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.deactivate
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.inode_limit
-r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.projects
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.remove_project
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.reset_block_limit_in_bytes
--w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.reset_inode_limit

3. To assign a project ID to container, just echo it to quota.add_project as:
echo "project100:100" > /cgroup/quota.add_project

To get a short list of the current projects assigned to container, user can check quota.projects,
# cat /cgroup/quota.projects
Project ID (project100:100)	status: off

The totally quota info can be check against quota.all, it will show something like below:
# cat /cgroup/quota.all
Project ID (project100:100)	status: off
  block_soft_limit	9223372036854775807
  block_hard_limit	9223372036854775807
  block_max_usage	0
  block_usage	0
  inode_soft_limit	9223372036854775807
  inode_hard_limit	9223372036854775807
  inode_max_usage	0
  inode_usage	0

Note that about "status: off", by default, a new assigned project will in OFF state, user could
turn it on by echo the project ID to quota.activate as below:
# echo 100 > /cgroup/quota.activate
# cat /cgroup/quota.all
Project ID (project100:100)	status: on	 *now  status changed.*
  block_soft_limit	9223372036854775807
  block_hard_limit	9223372036854775807
  block_max_usage	0
  block_usage	0
  inode_soft_limit	9223372036854775807
  inode_hard_limit	9223372036854775807
  inode_max_usage	0
  inode_usage	0

But it will do nothing since without quota setup.

4. To configure quota via cgroup, user need to interact with quota.inode_limit and quota.block_limit_in_bytes.
For now, I only add a simple inode quota check to XFS, it looks something like below:

# echo "100 2:4" >> /cgroup/quota.inode_limit
# cat /cgroup/quota.all
Project ID (project100:100)	status: on
  block_soft_limit	9223372036854775807
  block_hard_limit	9223372036854775807
  block_max_usage	0
  block_usage	0
  inode_soft_limit	2
  inode_hard_limit	4
  inode_max_usage	0
  inode_usage	0

# for ((i=0; i < 6; i++)); do touch xfs/quota_test/test.$i; done

Project ID (project100:100)	status: on
  block_soft_limit	9223372036854775807
  block_hard_limit	9223372036854775807
  block_max_usage	0
  block_usage	0
  inode_soft_limit	2
  inode_hard_limit	4
  inode_max_usage	4
  inode_usage	4

Sorry again, above steps crashed me sometimes for now, it works just for demo purpose. :)

Any criticism and suggestions are welcome!

Thanks,
-Jeff

fs/Makefile                  |    2 +
 fs/quota_cgroup.c            |  725 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c           |   30 ++
 fs/xfs/xfs_vnodeops.c        |   10 +
 include/linux/quota_cgroup.h |   60 ++++
 include/linux/res_counter.h  |    3 +
 init/Kconfig                 |    6 +
 kernel/res_counter.c         |   58 ++++
 8 files changed, 894 insertions(+), 0 deletions(-)
 create mode 100644 fs/quota_cgroup.c
 create mode 100644 include/linux/quota_cgroup.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
