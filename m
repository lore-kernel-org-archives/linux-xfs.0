Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Jul 2008 23:54:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m716sKbg005086
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 23:54:21 -0700
Message-ID: <4892B361.9030900@sgi.com>
Date: Fri, 01 Aug 2008 16:55:29 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Question about extended attributes...
References: <48925495.7040804@tlinx.org>
In-Reply-To: <48925495.7040804@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Linda,

Linda A. Walsh wrote:
> my man page says extended xfs attributes can have 256-byte names
> with up to 64K of data.
> 
> Is there a limit on the number of extended attributes max data size or
> name size?
> 
> I.e. could I have 1000 attributes with 64K of data each?
> 
Yep.

> Is there a strong reason why the file and data sizes were limited to
> 256/64K?

I presume by file you mean name.

In the various forms of an EA - shortform and leaf form, the
namelen is stored as 1 byte and so we can really only store 255 bytes
for a name AFAICT.

For the value part, I can see 3 forms in which it is short form or
in leaf-form with value local or value remote.

struct xfs_attr_sf_entry {
        __uint8_t namelen;      /* actual length of name (no NULL) */
        __uint8_t valuelen;     /* actual length of value (no NULL) */

typedef struct xfs_attr_leaf_name_local {
        __be16  valuelen;               /* number of bytes in value */
        __u8    namelen;                /* length of name bytes */

typedef struct xfs_attr_leaf_name_remote {
        __be32  valueblk;               /* block number of value bytes */
        __be32  valuelen;               /* number of bytes in value */
        __u8    namelen;                /* length of name bytes */

So from a valuelen pt-of-view we have 2^32-1.
Not sure about other limitations there.

I'm not sure why 64K was chosen for a value size limit.
In fact, on a quick look in the xfs code I can't see (other than in dmapi
and an assert in list) where we limit this.
We do limit it in the attr(1) userspace cmd by only reading up to ATTR_MAX_VALUELEN.
1 xfs/xfs_attr.h <global>               56 #define ATTR_MAX_VALUELEN (64*1024)
2 dmapi/xfs_dm.c xfs_dm_bulkall_one    685 if (value_len > ATTR_MAX_VALUELEN)
3 dmapi/xfs_dm.c xfs_dm_bulkall_one    686 value_len = ATTR_MAX_VALUELEN;
4 dmapi/xfs_dm.c xfs_dm_get_config    1584 retval = ATTR_MAX_VALUELEN;
5 dmapi/xfs_dm.c xfs_dm_get_dmattr    1957 if (alloc_size > ATTR_MAX_VALUELEN)
6 dmapi/xfs_dm.c xfs_dm_get_dmattr    1958 alloc_size = ATTR_MAX_VALUELEN;
7 dmapi/xfs_dm.c xfs_dm_set_dmattr    2623 if (buflen > ATTR_MAX_VALUELEN)
8 xfs/xfs_attr.c xfs_attr_put_listent  682 ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
And on IRIX we limited the value size in the vfs and not in the xfs code.
I wonder what would happen going straight to the setxattr syscall on an
xfs file.
Okay, we are limited by:
#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
And we have one for the name:
#define XATTR_NAME_MAX   255    /* # chars in an extended attribute name */

static long
setxattr(struct dentry *d, char __user *name, void __user *value,
         size_t size, int flags)
{
...
        if (size) {
                if (size > XATTR_SIZE_MAX)
                        return -E2BIG;

So the Linux interface will limit us here too by the looks of it.


> Would they be hard to 'generalize' to max-path-segment-len/max-filelen?
> 
> Only reason I wonder is wondering what file systems besides apple's
> "HPFS"(?) and
> MS's NTFS, that allow alternate data-streams of arbitrary length.  I'm
> not sure about
> the maximums on HPFS and NTFS, but I haven't _read_ of any notable
> limits (I'm sure
> there are some, but it _seems_ you can store alternate file versions in
> different data-streams
> on NTFS, for example...  I.e. could use it as a revision system,
> theoretically -- to save
> older versions of the file with the right software -- but with XFS, it
> wouldn't be so
> general case with a 64K data limit -- wouldn't be a show-stopper if one
> could 'link'
> multiple data-segments, but am just curious about the limitations (not
> that I'm planning
> on implementing a version control system using data-forks...it was just
> an example! :-)).
> 
> linda
> 

--Tim
