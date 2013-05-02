Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3EB047F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 03:25:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C8858F8035
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 01:25:06 -0700 (PDT)
Received: from emea01-am1-obe.outbound.protection.outlook.com
	(mail-am1lp0011.outbound.protection.outlook.com
	[213.199.154.11]) by cuda.sgi.com with ESMTP id
	Y16zB5ZsBgByHj74 (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 01:25:04 -0700 (PDT)
Message-ID: <518222D3.3080109@zynstra.com>
Date: Thu, 2 May 2013 09:24:51 +0100
From: James Dingwall <james.dingwall@zynstra.com>
MIME-Version: 1.0
Subject: Re: Cleancache support in XFS
References: <51810CED.4080003@zynstra.com> <20130501162044.GN29359@sgi.com>
	<20130501223022.GQ10481@dastard>
In-Reply-To: <20130501223022.GQ10481@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>, konrad.wilk@oracle.com
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, May 01, 2013 at 11:20:44AM -0500, Ben Myers wrote:
>> Hi James,
>>
>> On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
>>> In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
>>>
>>> $ grep -r cleancache fs/xfs
>>> on the 3.9 kernel source suggests that no patch was submitted to
>>> enable cleancache for the XFS filesystem.  Since it was suggested
>>> that this could be a one liner I've had a go and my first effort is
>>> inline below.  While this seems to compile OK I have no experience
>>> in filesystems so I would appreciate it if anyone can point out that
>>> it is obviously wrong and likely to eat my data before I try booting
>>> the kernel.
>>>
>>> If it seems a reasonable attempt what would be the best way to check
>>> that it isn't doing nasty things?
>> Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
>> includes a list of attributes the filesystem needs to have to work properly
>> with cleancache.
> So, those points are:
I had started to look at these too but I feel very out of my depth! I 
had similar conclusions to what Dave wrote but I don't think my thoughts 
should carry very much (any) weight.  Anyway I gambled and booted my xen 
domU with this patch and so far so good...  xen top shows that tmem is 
now being used where previously it wasn't.  I'll try running the 
xfstests at the weekend after a couple more days up time to see what 
happens.
>
> | Some points for a filesystem to consider:
> |
> | - The FS should be block-device-based (e.g. a ram-based FS such
> |  as tmpfs should not enable cleancache)
>
> OK.
>
> |- To ensure coherency/correctness, the FS must ensure that all
> |  file removal or truncation operations either go through VFS or
> |  add hooks to do the equivalent cleancache "invalidate" operations
>
> There be dragons - do all the XFS ioctls do the right thing?
vfs_unlink() calls *dir->i_op->unlink, in xfs_iops.c for S_IFDIR there is:

if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
         inode->i_op = &xfs_dir_ci_inode_operations;
else
         inode->i_op = &xfs_dir_inode_operations;

where .unlink in xfs_dir_inode_operations is xfs_vn_unlink() in either
condition.

I can't work out how to follow the vfs_truncate() in to the filesystem
code and perhaps there are other paths that would lead to file removal.

>
> |- To ensure coherency/correctness, either inode numbers must
> |  be unique across the lifetime of the on-disk file OR the
> |  FS must provide an "encode_fh" function.
>
> Ok.
>
> |- The FS must call the VFS superblock alloc and deactivate routines
> |  or add hooks to do the equivalent cleancache calls done there.
>
> OK.
>
> |- To maximize performance, all pages fetched from the FS should
> |  go through the do_mpag_readpage routine or the FS should add
> |  hooks to do the equivalent (cf. btrfs)
>
> xfs uses mpage_readpages() so should be fine.
I think there is a cleancache documentation bug since no other fs calls 
do_mpage_readpage().
>
> |- Currently, the FS blocksize must be the same as PAGESIZE.  This
> |  is not an architectural restriction, but no backends currently
> |  support anything different.
>
> Which means that we need hooks in the mount path to determine if
> this is the case or not. I note that neither ext3/ext4 do this check
> so I can't determine why this restriction is mentioned, and I'm not
> sure if it has any relevance to btrfs.
>
> IOWs, I'd like to know why this restriction exists - what does
> cleancache care about how the filesystem maps blocks to the page in
> the page cache - any way the filesystem does this it uses
> page->private to hide this fact from the page cache....
+ Konrad (cleancache maintainer) for any opinion.
>
> |- A clustered FS should invoke the "shared_init_fs" cleancache
> |  hook to get best performance for some backends.
>
> Not a problem.
>
> So there's a couple of things that need to be explained and
> explored, and a bunch of testing to be done....
>
James

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
