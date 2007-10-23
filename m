Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 03:01:27 -0700 (PDT)
Received: from ppsw-5.csi.cam.ac.uk (ppsw-5.csi.cam.ac.uk [131.111.8.135])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9NA1JBA028613
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 03:01:20 -0700
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-Id: <30F0B02B-9857-43E8-89C0-E9C85EF081A2@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Tue, 23 Oct 2007 11:01:11 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Hi,

On 23 Oct 2007, at 08:53, Barry Naujok wrote:
> Following is the initial test version of case-insensitive support
> for XFS in Linux. It implements case-insensitivity utilising a
> Unicode case folding table stored on disk generated from
> http://www.unicode.org/Public/UNIDATA/CaseFolding.txt
>
> As the filesystem stores names as Unicode (UTF-8), the "nls"
> mount option has been added to support systems not utilising
> UTF-8 natively. If the nls mount option is not used, it will
> use the default NLS defined in the kernel's config.
>
> To allow case-insensitivity to be a mount option rather than
> a mkfs option, the hashes stored on disk are always case-folded.
> This is indicated by the new "unicode" bit in the superblock.
> This bit also associated with the presence of the case-folding
> table on disk.
>
> With the case-folding table on disk, it allows us to upgrade
> the table in the future while retaining backwards and forwards
> compatibility. It also allows special case tables such as
> Turkic case which is supported in this patch set.
>
> The case-insensitive support also installs a couple of
> dentry_operations for the XFS inodes: hash and compare.
>
> Currently, there is a couple of outstanding issues with the
> dentry cache interaction:
>
>  - The first lookup if case-mismatched will continue to
>    have the mismatched case in the cache. Not really sure
>    if this is an issue or not. If it is an issue, how
>    should I resolve it?
>
>  - As above, but with a non-existing lookup, then creating
>    the file with a different case, the first failed lookup
>    will define the case used. I have partially resolved
>    this with a memcpy if the two lengths are the same.
>    How do I fix this if the lengths are different?
>    (TODO's show the location of this problem.)

Both of the above can be fairly easily fixed if you want.  NTFS does  
it in the stock kernel.

You would need to change the XFS ->lookup inode operation so that when  
it reads the directory to check whether a name exists, if it is found  
but the case is not matched, you need to make a copy of the correctly  
cased name (if NTFS this is done in fs/ntfs/ 
dir.c::ntfs_lookup_inode_by_name() if you want to take a look, the  
name is stored in the "ntfs_name" structure that is allocated during  
the lookup if a case mismatched match is found and this is returned to  
the caller).

Then in ->lookup() if you got a correctly cased name structure (if the  
name was cased correctly the correctly cased named structure pointer  
would be NULL) then you need to replace the dentry passed into - 
 >lookup with a new one with the correct case.  This is a little  
complicated because such a dentry may already exist in which case you  
have to use the existing one (instantiating it if it was negative) and  
if it does not already exist you need to allocate a new one,  
instantiate it and then move it over the old one.  Again a little  
complicated because of disconnected dentries for NFS.  But it is not  
too bad and it works well in NTFS (see fs/ntfs/namei.c::ntfs_lookup()  
the code that does all of this starts at the "handle_name" goto label).

Doing things this way means that you never have wrong case dentries in  
dcache.  And this in turn means that things like handling ->unlink and  
->rename inode operations is much easier as the dentry you receive  
there is returned from a ->lookup() call thus you know it is correctly  
cased already so you can do a case-sensitive match when looking up the  
directory entry to remove/rename!  (I am afraid you cannot look at the  
NTFS code for that as that is not publicly available yet. )-:)

Best regards,

	Anton

> Other TODOs:
>
>  - support for case-insensitve extended attributes
>    as a separate mount option.
>
>  - Other xfsprogs updates: xfs_repair, xfs_db

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
