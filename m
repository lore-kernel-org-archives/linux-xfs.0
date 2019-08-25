Return-Path: <SRS0=G8Dq=WV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F21C3A5A1
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 13:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 761FD20870
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Aug 2019 13:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elDWHFcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfHYNmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Aug 2019 09:42:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46567 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfHYNmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Aug 2019 09:42:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id m3so8735280pgv.13;
        Sun, 25 Aug 2019 06:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o5pCbY5E8C+OJFZcqJHFZSYbH1+aXSJ5fCYxJd3QXOA=;
        b=elDWHFcX9ZnlIgg+h1I9/Yqsw7MJGo3U5IrF8+khWUeBfojjcUVbGxbshc+xKJMtvQ
         n9sQhQt0zcqye6ObEbZ4dUWzhLRfH9TD64Xb+DmuLPYRStDMFH5R5ZHwE8KNliR2VmM/
         J0rzJIR57xBj7DMSz/9p0oD2s1fQYwbrnT+x73rrgveRwLkFuzZZ8/E3AwuVXZU8KJK2
         E8UgRXYqoCihNhAaF+wW/mf5/vo87d5Z2geCv6RYjCbQJyDV+43gJwF+DaJMwECdzvoK
         NljtQpw4nm+07fbYpKR0Z6KrAaem8oRoHGS++9ka4bHdT2t8Be3Csqsj7sk9+MoqW6/u
         dG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o5pCbY5E8C+OJFZcqJHFZSYbH1+aXSJ5fCYxJd3QXOA=;
        b=n6F4uRk2hY47AynDYrbNPwwuGk1mvGbbivQqX6XfBY3HLAr8q2StKMkt8z/xToJsrZ
         KW4T1kv+OIkflkO6tMiWThPG9VHEo+A7IC52bhWeqPVpnQZCVrFn46ZwOE759UDqDPqQ
         PvPR0lDySARe67wTIkvepDPuRnrJS+QyU0q73htL4r0QFG0c+PpC4YVvsIe0TAft2mg8
         jwKX7UUSPAMLMudjSBtaVgntpjVQDJ86i4h2hpQQ5hi0jZ0ODy6k+WM+PbM5Zyejt4Z9
         V1odSCmLxTuEe08IhxZOiDEEWveM31O7DbOZb7g8RLXSccwFdrXEo9vAPGVkBDHNbEho
         kxlQ==
X-Gm-Message-State: APjAAAVMcJcY22bCxlTmHteC6kF90P4lEAqK0341DWScMspq82yzkzAi
        AueNzRdbveb7coQxDz77M10=
X-Google-Smtp-Source: APXvYqyQ3I7cuy8OIAt776RDSOTdNmQEWqAFr2hrfrMtmXxEm4aRU8TWxp5itKfSCKrlrBJFflAOgg==
X-Received: by 2002:a62:1444:: with SMTP id 65mr15027153pfu.145.1566740526921;
        Sun, 25 Aug 2019 06:42:06 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id v8sm8621566pjb.6.2019.08.25.06.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 06:42:05 -0700 (PDT)
Date:   Sun, 25 Aug 2019 21:41:54 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] t_stripealign: Fix fibmap error handling
Message-ID: <20190825134154.GB2622@desktop>
References: <20190823092530.11797-1-cmaiolino@redhat.com>
 <20190823143650.GI1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823143650.GI1037350@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 07:36:50AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2019 at 11:25:30AM +0200, Carlos Maiolino wrote:
> > FIBMAP only returns a negative value when the underlying filesystem does
> > not support FIBMAP or on permission error. For the remaining errors,
> > i.e. those usually returned from the filesystem itself, zero will be
> > returned.
> > 
> > We can not trust a zero return from the FIBMAP, and such behavior made
> > generic/223 succeed when it should not.
> > 
> > Also, we can't use perror() only to print errors when FIBMAP failed, or
> > it will simply print 'success' when a zero is returned.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  src/t_stripealign.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/src/t_stripealign.c b/src/t_stripealign.c
> > index 5cdadaae..164831f8 100644
> > --- a/src/t_stripealign.c
> > +++ b/src/t_stripealign.c
> > @@ -76,8 +76,11 @@ int main(int argc, char ** argv)
> >  		unsigned int	bmap = 0;
> >  
> >  		ret = ioctl(fd, FIBMAP, &bmap);
> > -		if (ret < 0) {
> > -			perror("fibmap");
> > +		if (ret <= 0) {
> > +			if (ret < 0)
> > +				perror("fibmap");
> > +			else
> > +				fprintf(stderr, "fibmap error\n");
> 
> "fibmap returned no result"?

Fixed on commit. Thanks!

Eryu
