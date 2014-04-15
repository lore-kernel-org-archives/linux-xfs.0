Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9F1F7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 15:20:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 399CCAC005
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 13:20:12 -0700 (PDT)
Received: from emvm-gh1-uea08.nsa.gov (emvm-gh1-uea08.nsa.gov [63.239.67.9])
	by cuda.sgi.com with ESMTP id 4Dma6hB4qXmQQpNp for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 13:20:10 -0700 (PDT)
Message-ID: <534D9399.2090407@tycho.nsa.gov>
Date: Tue, 15 Apr 2014 16:16:25 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
	<20140415175033.GB26404@infradead.org>
	<534D90D0.9090805@tycho.nsa.gov>
In-Reply-To: <534D90D0.9090805@tycho.nsa.gov>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, xfs@oss.sgi.com

On 04/15/2014 04:04 PM, Stephen Smalley wrote:
> On 04/15/2014 01:50 PM, Christoph Hellwig wrote:
>> On Tue, Apr 15, 2014 at 12:18:24PM -0400, Brian Foster wrote:
>>> +	error = xfs_init_security(inode, dir, &dentry->d_name);
>>> +	if (unlikely(error)) {
>>> +		iput(inode);
>>> +		return -error;
>>> +	}
>>> +
>>>  	d_tmpfile(dentry, inode);
>>>  
>>
>> I'd really love to hear from the LSM people who they plan to deal with
>> O_TMPFILE inodes.    But given that this seems to fix a real life bug
>> let's go with it for now.
> 
> Is there a reason that xfs_init_security() isn't called from the inode
> allocation function (e.g. xfs_ialloc), as in ext4 (__ext4_new_inode
> calls ext4_init_security and also calls ext4_init_acl)?  That would have
> ensured that tmpfile inodes would have been labeled without requiring a
> separate change and more generally ensures complete coverage for all inodes.
> 
> For SELinux, we need the tmpfile inodes to be labeled at creation time,
> not just if linked into the namespace, since they may be shared via
> local socket IPC or inherited across a label-changing exec and since we
> revalidate access on transfer or use.
> 
> Labeling based on the provided directory could be a bit random, although
> it will work out with current policy if the provided directory
> corresponds to existing tmpfile locations (e.g. /tmp, /var/tmp) and
> therefore already has a label associated with temporary files.
> Otherwise we might want some indication that it is a tmpfile passed into
> security_inode_init_security() so that we can always select a stable
> label irrespective of the directory.

Hmm...wondering if we can use the qstr as a distinguisher; pass NULL for
tmpfile and not for others as in ext4?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
