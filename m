Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:32:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m331W4RU005120
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:32:06 -0700
Subject: Re: [PATCH 7/7] XFS: NLS config option
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.577869936@chook.melbourne.sgi.com> <20080403012610.GD5211@josefsipek.net>
Date: Thu, 03 Apr 2008 11:38:11 +1000
Message-ID: <op.t80hhxue3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080403012610.GD5211@josefsipek.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, 03 Apr 2008 11:26:10 +1000, Josef 'Jeff' Sipek  
<jeffpc@josefsipek.net> wrote:

> On Wed, Apr 02, 2008 at 04:25:15PM +1000, Barry Naujok wrote:
>> This optional patch implements the NLS support as a CONFIG option.
>
> Any reason this is a separate patch, and not part of the previous  
> patches?
>
> ...
>> --- kern_ci.orig/fs/xfs/Kconfig
>> +++ kern_ci/fs/xfs/Kconfig
>> @@ -87,6 +87,16 @@ config XFS_UNICODE
>>
>>  	  If you don't require UTF-8 enforcement, say N.
>>
>> +config XFS_UNICODE_NLS
>> +	bool "XFS NLS Unicode support
>> +	depends on XFS_UNICODE
>> +	help
>> +	  NLS (Native Language Support) allows non-UTF8 locales to
>> +	  interact with XFS Unicode support. To specify the character
>> +	  set being used, use the "-n nls=<charset>" mount option.
>
> "mount option"? Or was that supposed to say mkfs?

Hmm... typo: "-o nls=<charset>" in mount :)

> from mount(8) manpage:
>
>        -n     Mount without writing in /etc/mtab.  This is necessary for
>               example when /etc is on a read-only file system.
>
> ...
>> Index: kern_ci/fs/xfs/xfs_unicode.h
>> ===================================================================
>> --- kern_ci.orig/fs/xfs/xfs_unicode.h
>> +++ kern_ci/fs/xfs/xfs_unicode.h
>> @@ -65,6 +65,8 @@ int xfs_unicode_validate(const uchar_t *
>>  int xfs_unicode_read_cft(struct xfs_mount *mp);
>>  void xfs_unicode_free_cft(const xfs_cft_t *cft);
>>
>> +#ifdef CONFIG_XFS_UNICODE_NLS
>> +
>>  #define xfs_is_using_nls(mp)	((mp)->m_nls != NULL)
>>
>>  int xfs_unicode_to_nls(struct xfs_mount *mp, const uchar_t *uni_name,
>> @@ -73,7 +75,20 @@ int xfs_nls_to_unicode(struct xfs_mount
>>  		int nls_namelen, const uchar_t **uni_name, int *uni_namelen);
>>  void xfs_unicode_nls_free(const uchar_t *src_name, const uchar_t  
>> *conv_name);
>>
>> -#else
>> +#else /* CONFIG_XFS_UNICODE_NLS */
>> +
>> +#define xfs_is_using_nls(mp)		0
>> +
>> +#define xfs_unicode_to_nls(mp, uname, ulen, pnname, pnlen) \
>> +		((*(pnname)) = (uname), (*(pnlen)) = (ulen), 0)
>> +#define xfs_nls_to_unicode(mp, nname, nlen, puname, pulen) \
>> +		((*(puname)) = (nname), (*(pulen)) = (nlen), \
>> +		 xfs_unicode_validate(nname, nlen))
>
> While I commend your use of the comma operator, I really think those  
> should
> be static inlines :)
>
> Josef 'Jeff' Sipek.
>
