Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6942E7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 12:13:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58ED48F8035
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 10:13:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ekpznmNIs2pKP67v for
	<xfs@oss.sgi.com>; Thu, 06 Mar 2014 10:12:59 -0800 (PST)
Date: Thu, 6 Mar 2014 19:02:16 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
In-Reply-To: <20140306174813.GE28297@infradead.org>
Message-ID: <alpine.LFD.2.00.1403061900300.2249@localhost.localdomain>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
	<1394034699-21187-7-git-send-email-lczerner@redhat.com>
	<20140306174813.GE28297@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, 6 Mar 2014, Christoph Hellwig wrote:

> Date: Thu, 6 Mar 2014 09:48:13 -0800
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
> 
> > +#ifdef HAVE_LINUX_FIEMAP_H
> > +struct print_flags fiemap_flags[] = {
> > +	{ FIEMAP_FLAG_SYNC, "SYNC"},
> > +	{ FIEMAP_FLAG_XATTR, "XATTR"},
> > +	{ -1, NULL}
> > +};
> 
> Can be static.

Right. The same applies to falloc_flags

> 
> > +
> > +#define translate_fiemap_flags(mode)	\
> > +	({translate_flags(mode, "|", fiemap_flags);})
> > +#endif
> 
> Any reason to not have these two inside fiemap_f?

Not really, other than I think it's ugly.

> 
> Otherwise:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
