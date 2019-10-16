Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45FAC4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F8A921835
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SnmKh5Qy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfJPIgR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:36:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfJPIgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FYislZGYhm78W+eSwn8FZ3HsvYt1lLcQu3Twjs2JSZI=; b=SnmKh5QyQTM5woT1IrOJHAnOI
        znk7MxB7w7wgfADiHLCz0rIBPF1X/iXl16eoKKO/EbnOJpvAE+3bSmoSxA4+wq+Vc4JD7OpxfCgO8
        OQXscm5Y4sa6zdiLJdYSFBZFH8v3/iZySQRtOe07Vz29SzanT6nbIrcYKHZpBmf4ffaYnwIfsbhG7
        VtbHfr8DeLVKSUrmUrfiOdowW8/t1CDwoK15/aMl5W77vzMAMYgINRDUkC1EbAmKAs2JhBE3CayaT
        bRRIJYel6/Ks5GbIb7Q4HCLZ9Q8iS80hfynijesEwiya/rIs/xOu1KhmZZedYlWuj/+LNrTIvTxLK
        zdLoMexNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKen2-0005dT-TF; Wed, 16 Oct 2019 08:36:16 +0000
Date:   Wed, 16 Oct 2019 01:36:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 09/12] xfs: refactor xfs_parseags()
Message-ID: <20191016083616.GH29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118649265.9678.734489676015273741.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118649265.9678.734489676015273741.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:32AM +0800, Ian Kent wrote:
> Refactor xfs_parseags(), move the entire token case block to a
> separate function in an attempt to highlight the code that
> actually changes in converting to use the new mount api.
> 
> The only changes are what's needed to communicate the variables
> dsunit, dswidth and iosizelog back to xfs_parseags().

Use up the full space avaiable for commit log, please.

> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		break;
> +	case Opt_discard:
> +		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		break;
> +	case Opt_nodiscard:
> +		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		break;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		break;
> +#endif
> +	default:
> +		xfs_warn(mp, "unknown mount option [%s].", p);
> +		return -EINVAL;
> +	}
> +
> +	return 0;

It seems all these breaks could simply directly do a return 0, make
the function a tidbit easier to read.

> +		ret = xfs_parse_param(token, p, args, mp,
> +				      &dsunit, &dswidth, &iosizelog);

Please use up the full 80 chars on the first line
