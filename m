Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8E2C3A59E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 06:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22DA6206BA
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 06:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfHZGsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbfHZGsv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 02:48:51 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CB0B80F79
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 06:48:51 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id c11so3836949wml.6
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2019 23:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=CcFDbD9TUQ2fa08YKYlJuwV0y2lJ4AYtyELPlx8Ewoo=;
        b=RSv3KY1sc+BN/YKPDgQhWr0LbsLD9ozur8O5rOk1oWEld5ZuDEm854auBVeZG2ZFRW
         ReC81fEzG8FkkZgiCiWapliCLkAEZQYn1rN/r9cxPnvj0MYw2TxIPTM7wYAWCNDJfMnA
         RL7FJkH4AEr5WfsVVFA7ZTr44IzrQjuuU6dQvPO/3ywqdVqnI1OCcJqjlNYnPOj3HMfm
         bFS+9+Xr+uuT09Ad/Ogr2S3DnMLKxRscUGEE6E8cUd0GEbZfFPNBoBIuJ+zPm2XokcbW
         q7i0CbaexUM3mnEFE3ccGrMoFz1ZSGcXTxfbjzI41gha9l4dwSzXJ4b/eaynzGBrVt89
         fi7Q==
X-Gm-Message-State: APjAAAVuYK2JyOb52JaLgevso2cp8uYO9S6NSe5jMsLug2uLlNQxkeR9
        AssNgGzr8albxch7XylD1h25S+ep64orwLmhei/VI64afXgoghXw1jVgnfSryq2luVfs1kOfl6E
        n1es90JhmF0OYngyJsgSX
X-Received: by 2002:a05:6000:4f:: with SMTP id k15mr19683742wrx.221.1566802129921;
        Sun, 25 Aug 2019 23:48:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwxbzsHGoiKFsZvDx2Rn9JzEBKdCmKH4gZ14956Rzy2iiWU8uK+27dbOhR9azINdizVxtRTSg==
X-Received: by 2002:a05:6000:4f:: with SMTP id k15mr19683717wrx.221.1566802129701;
        Sun, 25 Aug 2019 23:48:49 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id p7sm8801009wmh.38.2019.08.25.23.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:48:49 -0700 (PDT)
Date:   Mon, 26 Aug 2019 08:48:47 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] t_stripealign: Fix fibmap error handling
Message-ID: <20190826064846.vx5jb7ugrsxyd34x@pegasus.maiolino.io>
Mail-Followup-To: Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20190823092530.11797-1-cmaiolino@redhat.com>
 <20190823143650.GI1037350@magnolia>
 <20190825134154.GB2622@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190825134154.GB2622@desktop>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 25, 2019 at 09:41:54PM +0800, Eryu Guan wrote:
> On Fri, Aug 23, 2019 at 07:36:50AM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 23, 2019 at 11:25:30AM +0200, Carlos Maiolino wrote:
> > > FIBMAP only returns a negative value when the underlying filesystem does
> > > not support FIBMAP or on permission error. For the remaining errors,
> > > i.e. those usually returned from the filesystem itself, zero will be
> > > returned.
> > > 
> > > We can not trust a zero return from the FIBMAP, and such behavior made
> > > generic/223 succeed when it should not.
> > > 
> > > Also, we can't use perror() only to print errors when FIBMAP failed, or
> > > it will simply print 'success' when a zero is returned.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  src/t_stripealign.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/src/t_stripealign.c b/src/t_stripealign.c
> > > index 5cdadaae..164831f8 100644
> > > --- a/src/t_stripealign.c
> > > +++ b/src/t_stripealign.c
> > > @@ -76,8 +76,11 @@ int main(int argc, char ** argv)
> > >  		unsigned int	bmap = 0;
> > >  
> > >  		ret = ioctl(fd, FIBMAP, &bmap);
> > > -		if (ret < 0) {
> > > -			perror("fibmap");
> > > +		if (ret <= 0) {
> > > +			if (ret < 0)
> > > +				perror("fibmap");
> > > +			else
> > > +				fprintf(stderr, "fibmap error\n");
> > 
> > "fibmap returned no result"?
> 
> Fixed on commit. Thanks!

TZ discrepancy. Thanks for fixing it on commit Eryu :)


> 
> Eryu

-- 
Carlos
