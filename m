Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 21:49:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m334naBs005547
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 21:49:46 -0700
Date: Thu, 03 Apr 2008 14:50:39 +1000
Subject: Re: [PATCH 1/7] XFS: Name operation vector for hash and compare
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062707.797672682@chook.melbourne.sgi.com> <20080403002246.GB5211@josefsipek.net>
Message-ID: <op.t80qepmm3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080403002246.GB5211@josefsipek.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, 03 Apr 2008 10:22:46 +1000, Josef 'Jeff' Sipek  
<jeffpc@josefsipek.net> wrote:

> On Wed, Apr 02, 2008 at 04:25:09PM +1000, Barry Naujok wrote:
> ...
>> +/*
>> + * Name ops for directory and/or attr name operations
>> + */
>> +
>> +typedef xfs_dahash_t	(*xfs_hashname_t)(const uchar_t *, int);
>> +typedef xfs_dacmp_t	(*xfs_compname_t)(const uchar_t *, int,
>> +					  const uchar_t *, int);
>
> Why have typedefs for function pointers? Sometimes, they even cause  
> problems
> (I remember Eric finding a nasty 64-bit bug related to a function pointer
> typedef).
>
> Since IRIX isn't on the supported OS list anymore, what's the policy with
> coding style within XFS?

Ok, I have fixed it:

+/*
+ * Name ops for directory and/or attr name operations
+ */
+struct xfs_nameops {
+	xfs_dahash_t (*hashname)(const uchar_t *, int);
+	xfs_dacmp_t  (*compname)(const uchar_t *, int, const uchar_t *, int);
+};

> ...
>> Index: kern_ci/fs/xfs/xfs_dir2.h
>> ===================================================================
>> --- kern_ci.orig/fs/xfs/xfs_dir2.h
>> +++ kern_ci/fs/xfs/xfs_dir2.h
>> @@ -85,6 +85,12 @@ extern int xfs_dir_canenter(struct xfs_t
>>  				char *name, int namelen);
>>  extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
>>
>> +#define xfs_dir_hashname(dp, n, l) \
>> +		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
>> +
>> +#define xfs_dir_compname(dp, n1, l1, n2, l2) \
>> +		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))
>
> #define vs. static inline...
>
> I guess this comes back to my question before...what is the coding style
> direction you want XFS to go in? More Linux-like (static inline)? or  
> keep it
> more IRIX-like (#define)?

Nasty gotcha in this scenario, I have added a comment before them:

+/*
+ * Macros are used calling for the xfs_inode's xfs_mount's name  
operations as
+ * in most cases, xfs_dir2.h is included before xfs_inode.h and  
xfs_mount.h.
+ */
+#define xfs_dir_hashname(dp, n, l) \
+		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
+
+#define xfs_dir_compname(dp, n1, l1, n2, l2) \
+		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))

The alternative is reorganising the #includes in most of the .c files!
