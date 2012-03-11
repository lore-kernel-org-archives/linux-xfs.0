Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2BDpBQo125751 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 08:51:11 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id RsF180wlcPf42Znj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 06:51:09 -0700 (PDT)
Message-ID: <4F5C8361.5070303@oracle.com>
Date: Sun, 11 Mar 2012 18:50:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v1 0/4] cgroup quota
References: <4F59E78A.7060903@oracle.com> <4F5C8A0C.8050904@parallels.com>
In-Reply-To: <4F5C8A0C.8050904@parallels.com>
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
To: Glauber Costa <glommer@parallels.com>
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, cgroups@vger.kernel.org, lxc-devel@lists.sourceforge.net, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Christopher Jones <christopher.jones@oracle.com>, tj@kernel.org, tytso@MIT.EDU, Chris Mason <chris.mason@oracle.com>

Hi Glauber,

On 03/11/2012 07:18 PM, Glauber Costa wrote:

> On 03/09/2012 03:20 PM, Jeff Liu wrote:
>> Hello,
>>
>> Disk quota feature has been asked at LXC list from time to time.
>> Given that the project quota has already implemented in XFS for a long
>> time, and it was also in progress for EXT4.
>> So the major idea is to assign one or more project IDs(or tree ID?) to
>> container, but leaving quota setup via cgroup
>> config files, so all the tasks running at container could have project
>> quota constraints applied.
>>
>> I'd like to post an initial patch sets here, the stupid implements is
>> very simple and even crash me
>> in some cases, sorry! But I would like to submit it to get more
>> feedback to make sure I am going down
>> the right road. :)
>>
>> Let me introduce it now.
>>
>> 1. Setup project quota on XFS(enabled pquota) firstly.
>> For example, the "project100" is configured on "/xfs/quota_test"
>> directory.
>>
>> $ cat /etc/projects
>> 100:/xfs/quota_test
>>
>> $ cat /etc/projid
>> project100:100
>>
>> $ sudo xfs_quota -x -c 'report -p'
>> Project quota on /xfs (/dev/sda7)
>>                                 Blocks
>> Project ID       Used       Soft       Hard    Warn/Grace
>> ---------- --------------------------------------------------
>> project100          0          0          0     00 [--------]
>>
>> 2. Mount cgroup on /cgroup.
>> cgroup on /cgroup type cgroup (rw)
>>
>> After that, there will have a couple of quota.XXXX files presented at
>> /cgroup.
>> $ ls -l /cgroup/quota.*
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.activate
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.add_project
>> -r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.all
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.block_limit_in_bytes
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.deactivate
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.inode_limit
>> -r--r--r-- 1 root root 0 Mar  9 18:27 /cgroup/quota.projects
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.remove_project
>> --w------- 1 root root 0 Mar  9 18:27
>> /cgroup/quota.reset_block_limit_in_bytes
>> --w------- 1 root root 0 Mar  9 18:27 /cgroup/quota.reset_inode_limit
>>
>> 3. To assign a project ID to container, just echo it to
>> quota.add_project as:
>> echo "project100:100">  /cgroup/quota.add_project
>>
>> To get a short list of the current projects assigned to container,
>> user can check quota.projects,
>> # cat /cgroup/quota.projects
>> Project ID (project100:100)    status: off
>>
>> The totally quota info can be check against quota.all, it will show
>> something like below:
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: off
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    9223372036854775807
>>    inode_hard_limit    9223372036854775807
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> Note that about "status: off", by default, a new assigned project will
>> in OFF state, user could
>> turn it on by echo the project ID to quota.activate as below:
>> # echo 100>  /cgroup/quota.activate
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: on     *now  status changed.*
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    9223372036854775807
>>    inode_hard_limit    9223372036854775807
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> But it will do nothing since without quota setup.
>>
>> 4. To configure quota via cgroup, user need to interact with
>> quota.inode_limit and quota.block_limit_in_bytes.
>> For now, I only add a simple inode quota check to XFS, it looks
>> something like below:
>>
>> # echo "100 2:4">>  /cgroup/quota.inode_limit
>> # cat /cgroup/quota.all
>> Project ID (project100:100)    status: on
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    2
>>    inode_hard_limit    4
>>    inode_max_usage    0
>>    inode_usage    0
>>
>> # for ((i=0; i<  6; i++)); do touch xfs/quota_test/test.$i; done
>>
>> Project ID (project100:100)    status: on
>>    block_soft_limit    9223372036854775807
>>    block_hard_limit    9223372036854775807
>>    block_max_usage    0
>>    block_usage    0
>>    inode_soft_limit    2
>>    inode_hard_limit    4
>>    inode_max_usage    4
>>    inode_usage    4
>>
>> Sorry again, above steps crashed me sometimes for now, it works just
>> for demo purpose. :)
>>
>> Any criticism and suggestions are welcome!
> 
> I have mixed feelings about this. The feature is obviously welcome, but
> I am not sure if
> the approach you took is the best one... I'll go through the patches
> now, and hopefully will
> have a better opinion by the end =)

Thanks for your response!

Daniel has pointed me that Anqin had gave a try for implementing
container quota feature in UID/GUID form back to 2009, his patch set can
be found at:
https://lkml.org/lkml/2009/2/23/35

However, He had to give up because of a new job.

Looks a possible approach is to combine cgroup with project quota(or
tree quota?) according to the feedback from Paul at that time:
https://lkml.org/lkml/2009/2/23/35

So I wrote this draft patch out to present my basic ideas(even not
consider xattr storage space for XFS in current demo).

I am definitely a newbie in this area, so please forgive me if I make
some stupid mistakes. :)

Thanks,
-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
