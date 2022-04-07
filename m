Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FCDC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiDGLJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiDGLJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 07:09:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 314CD8F9A1
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649329624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cY1aDjBYdCizUYh+aHLT+USlT9By62PO7MzsOkY+P3o=;
        b=GWhlOxUbwGIyWbCJwBnfanM6sFo25LL98mFRbLllum+xE0a9DkcQDm+AfHTnU1s+FwpPnl
        Mebv9+HVPqubivZNmXLSdWexhf6si8TFQOqt8nEh5r1s8EPvmEzwBD2Pyl4ariJpQ7qIWh
        MIdX8h/rgrenVLxQopHhK1GOuywuy6M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-RmS8we0HNOSSlXLarb9QYw-1; Thu, 07 Apr 2022 07:07:03 -0400
X-MC-Unique: RmS8we0HNOSSlXLarb9QYw-1
Received: by mail-wr1-f69.google.com with SMTP id d29-20020adfa35d000000b002060fd92b14so1160805wrb.23
        for <linux-xfs@vger.kernel.org>; Thu, 07 Apr 2022 04:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cY1aDjBYdCizUYh+aHLT+USlT9By62PO7MzsOkY+P3o=;
        b=LVoXclkIGIoz/NtTFg8Y2gU8BINwJ2+lWsUWJKD9GAoeuJ8I5DoOQF7Lp/KWibXxvq
         nWF0joWQ4gYWkESE9KN/nP2/Szq/tMYVUkXvW+VVJjJwS7scQA3Vzi3Otba7k43IMySE
         PT2SnCnw53FPiMWX/pX2TkxOieDPhlzNiSVJTn5qMZIcjQWfs6RJ+WgI0Jwvlh8Tg1Dn
         FANDl3btnahdqbvR1vpUd/M5koo+mWV2fVokZt/w7KunpaF74LVmiqkqb1ULyOzQ7Sss
         l87Uq+RMjueP8iiEa3liappi1qh3/hSQ8wFyVQ9UNAg5V62wLllWxi2wq/DJnl9CH/YH
         oXcA==
X-Gm-Message-State: AOAM533pCLqMCn43HfF4AsjYrrVFxKlRYhIUjTjg/Gqb72OUTpyHOagH
        x/Q6vpukOSVP1NkXJm5RsST1YV1+Xf/nyCwTEKTRHmZhcML5U+SfJsuSNIoM2SNz9x42zEIAjVZ
        cO05d8vZScrwVVnHhimc=
X-Received: by 2002:adf:cf12:0:b0:203:f917:82ba with SMTP id o18-20020adfcf12000000b00203f91782bamr10497700wrj.538.1649329621553;
        Thu, 07 Apr 2022 04:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNQsUTXGMOpmsNwAQdaQy5J1ipm6GI4cKBUpftVF4uCgO6lUbuSMiUlpuWPSpvdIaCmdvusA==
X-Received: by 2002:adf:cf12:0:b0:203:f917:82ba with SMTP id o18-20020adfcf12000000b00203f91782bamr10497690wrj.538.1649329621372;
        Thu, 07 Apr 2022 04:07:01 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p2-20020a1c7402000000b0038159076d30sm7391013wmc.22.2022.04.07.04.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 04:07:00 -0700 (PDT)
Date:   Thu, 7 Apr 2022 13:06:56 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_quota: split get_quota() and
 report_mount()/dump_file()
Message-ID: <Yk7F0CM+DKf2wEYA@aalbersh.remote.csb>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-4-aalbersh@redhat.com>
 <Yk3Bp4rPbukT9VC7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk3Bp4rPbukT9VC7@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey Christoph,

On Wed, Apr 06, 2022 at 09:36:55AM -0700, Christoph Hellwig wrote:
> Can you explain the split and the reason for it a little more here?
> 
> >  dump_file(
> >  	FILE		*fp,
> >  	fs_disk_quota_t *d,
> > -	uint		id,
> > -	uint		*oid,
> > -	uint		type,
> > -	char		*dev,
> > -	int		flags)
> > +	char		*dev)
> >  {
> > -	if	(!get_quota(d, id, oid, type, dev, flags))
> > -		return 0;
> 
> I think it would make more sense to move this into the previous
> patch that passes the fs_disk_quota to dump_file.
> 
> And maybe this and the previous patch should be split into one for
> dump_file and one for report_mount?

I did it like this initially but it appeared to me that the diff was
messy. As there were many &d -> d and report_mount ->
get_quota/report_mount replacements, so I split it. But I'm not
against reshaping this back, should I do it?

> 
> > +			while ((g = getgrent()) != NULL) {
> > +				get_quota(&d, g->gr_gid, NULL, type, mount->fs_name, 0);
> 
> Overly long line.  (and a few more below).
> 

-- 
- Andrey

