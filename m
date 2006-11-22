Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 20:55:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM4ssaG001087
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 20:54:57 -0800
Message-ID: <4563D7DD.1060907@melbourne.sgi.com>
Date: Wed, 22 Nov 2006 15:53:49 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com> <20061122004216.GT11034@melbourne.sgi.com> <1164157783.19915.46.camel@xenon.msp.redhat.com> <20061122042445.GR37654165@melbourne.sgi.com>
In-Reply-To: <20061122042445.GR37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



David Chinner wrote:
> On Tue, Nov 21, 2006 at 07:09:43PM -0600, Russell Cattelan wrote:
>> On Wed, 2006-11-22 at 11:42 +1100, David Chinner wrote:
>>> Ok, so I've had time to look at this again. Here's the definitions
>>> of STATIC and STATIC_INLINE for debug and nondebug from the
>>> patch (whitespace damaged):
> .....
>>> Is this acceptible to everyone?
>> Yup.
>>
>>> FWIW, there is one other thing that this conversion causes
>>> problems with, and that's variable definitions. i.e. we can't
>>> use STATIC on them any more because of the "noinline" attribute
>>> it has. Do we care about this and if so, any suggestions on
>>> how to keep this functionality (a different STATIC_xxx define
>>> for structures)?
>> So I know things like systemtap kgdb oprofile all work better when
>> functions are not static, but what about variables/structures?
>> do things really get that confused?
>> Maybe we shouldn't worry about conditioning them and just make them
>> static
> 
> Ok, so I'd already converted them to static where necessary.
> Attached is thecomplete patch. On ia64, the size of the xfs.ko
> and xfs_quota.ko modules decreases with this patch:
> 
> Orig:
> 
> -rw-rw-r-- 1 dgc ptg  1662416 2006-11-22 14:41 fs/xfs/quota/xfs_quota.ko
> -rw-rw-r-- 1 dgc ptg   856748 2006-11-22 14:41 fs/xfs/xfsidbg.ko
> -rw-rw-r-- 1 dgc ptg 13614719 2006-11-22 14:41 fs/xfs/xfs.ko
> 
> With patch:
> 
> -rw-rw-r-- 1 dgc ptg  1657814 2006-11-22 14:42 fs/xfs/quota/xfs_quota.ko
> -rw-rw-r-- 1 dgc ptg   856748 2006-11-22 14:42 fs/xfs/xfsidbg.ko
> -rw-rw-r-- 1 dgc ptg 13557579 2006-11-22 14:42 fs/xfs/xfs.ko
> 
> The original top 10 stack users:
> 
> 0x000e10c6 xfs_vn_mknod [xfs]:                          576
> 0x000ddfe6 xfs_ioctl [xfs]:                             368
> 0x000e1f46 xfs_vn_symlink [xfs]:                        368
> 0x000345a6 xfs_bmapi [xfs]:                             320
> 0x000b1146 _xfs_trans_commit [xfs]:                     272
> 0x000c59c6 xfs_change_file_space [xfs]:                 272
> 0x0003a6a6 xfs_bunmapi [xfs]:                           240
> 0x000afa06 xfs_trans_unreserve_and_mod_sb [xfs]:        224
> 0x00040626 xfs_bmbt_insert [xfs]:                       192
> 0x0008be26 xfs_iomap_write_delay [xfs]:                 192
> 
> [64 functions with stack usage larger than 100 bytes]
> 
> With patch:
> 
> 0x000b7c46 _xfs_trans_commit [xfs]:                     272
> 0x000b5426 xfs_trans_unreserve_and_mod_sb [xfs]:        224
> 0x000e4106 xfs_find_handle [xfs]:                       224
> 0x000396c6 xfs_bmapi [xfs]:                             208
> 0x00090066 xfs_iomap_write_delay [xfs]:                 208
> 0x000e9046 xfs_cleanup_inode [xfs]:                     208
> 0x000058c6 xfs_acl_setmode [xfs]:                       160
> 0x00005f46 xfs_acl_allow_set [xfs]:                     160
> 0x000067c6 xfs_acl_vtoacl [xfs]:                        160
> 0x00007366 xfs_acl_vget [xfs]:                          160
> 
> [69 functions with stack usage larger than 100 bytes]
> 
> Performance appears to be slight faster with the noinline
> patch, but the variation is within the error margins of
> my measurements so I'd say it's neutral.
> 
> Comments?
> 

Just reducing xfs_bmapi by 118 bytes makes this worthwhile doesn't it?

Out of interest, what estimated improvement does this have on one of Jesper's
stacks?

Should we be concerned that there are now more functions with 100 or more bytes?

David

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
