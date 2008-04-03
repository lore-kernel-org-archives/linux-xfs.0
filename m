Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:43:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m331h8kb007358
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:43:09 -0700
Date: Wed, 2 Apr 2008 21:26:10 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 7/7] XFS: NLS config option
Message-ID: <20080403012610.GD5211@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.577869936@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062709.577869936@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:15PM +1000, Barry Naujok wrote:
> This optional patch implements the NLS support as a CONFIG option.

Any reason this is a separate patch, and not part of the previous patches?

...
> --- kern_ci.orig/fs/xfs/Kconfig
> +++ kern_ci/fs/xfs/Kconfig
> @@ -87,6 +87,16 @@ config XFS_UNICODE
>  
>  	  If you don't require UTF-8 enforcement, say N.
>  
> +config XFS_UNICODE_NLS
> +	bool "XFS NLS Unicode support
> +	depends on XFS_UNICODE
> +	help
> +	  NLS (Native Language Support) allows non-UTF8 locales to
> +	  interact with XFS Unicode support. To specify the character
> +	  set being used, use the "-n nls=<charset>" mount option.

"mount option"? Or was that supposed to say mkfs?


from mount(8) manpage:

       -n     Mount without writing in /etc/mtab.  This is necessary for
              example when /etc is on a read-only file system.

...
> Index: kern_ci/fs/xfs/xfs_unicode.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_unicode.h
> +++ kern_ci/fs/xfs/xfs_unicode.h
> @@ -65,6 +65,8 @@ int xfs_unicode_validate(const uchar_t *
>  int xfs_unicode_read_cft(struct xfs_mount *mp);
>  void xfs_unicode_free_cft(const xfs_cft_t *cft);
>  
> +#ifdef CONFIG_XFS_UNICODE_NLS
> +
>  #define xfs_is_using_nls(mp)	((mp)->m_nls != NULL)
>  
>  int xfs_unicode_to_nls(struct xfs_mount *mp, const uchar_t *uni_name,
> @@ -73,7 +75,20 @@ int xfs_nls_to_unicode(struct xfs_mount 
>  		int nls_namelen, const uchar_t **uni_name, int *uni_namelen);
>  void xfs_unicode_nls_free(const uchar_t *src_name, const uchar_t *conv_name);
>  
> -#else
> +#else /* CONFIG_XFS_UNICODE_NLS */
> +
> +#define xfs_is_using_nls(mp)		0
> +
> +#define xfs_unicode_to_nls(mp, uname, ulen, pnname, pnlen) \
> +		((*(pnname)) = (uname), (*(pnlen)) = (ulen), 0)
> +#define xfs_nls_to_unicode(mp, nname, nlen, puname, pulen) \
> +		((*(puname)) = (nname), (*(pulen)) = (nlen), \
> +		 xfs_unicode_validate(nname, nlen))

While I commend your use of the comma operator, I really think those should
be static inlines :)

Josef 'Jeff' Sipek.

-- 
Only two things are infinite, the universe and human stupidity, and I'm not
sure about the former.
		- Albert Einstein
