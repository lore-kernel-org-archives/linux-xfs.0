Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7C2C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EE7206B7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=davidb.org header.i=@davidb.org header.b="S24H+bFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCMOn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:43:26 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:41872 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCMOn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 10:43:26 -0400
Received: by mail-qt1-f174.google.com with SMTP id l21so7637098qtr.8
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2020 07:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidb.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVOdjAomzkcJYMgAthO69G0kiY/r0K9/P2d74w84F1c=;
        b=S24H+bFcp4SBqXcHg+HHfXg5UUvKTKpMhpeNQjyyAVp60+SyfE3C0QBCTfwDruu6de
         BTYoFATLPhH+B77k7KD4sw0JAdT8+m6ZT1keayKIklNXLPtXzA2R1ccs3+ioT1s4dyOS
         wPLAASUCfLf1PHljLpZBUUfSYzjIuJr91z3tHP+BEndnlxjqjOTUcmX3XW4nceCLPrhH
         7bs8A00zA2OUZgDcyLTt0zQLDtCt5Y83nQRIqyI2R7AjD5kMeiB9OE/oG1SPkWkFnyee
         0Kc73IWlparU/nwy5aBxIBN4fiUX1amHxlOtIH9FA0QwVh3QUKrUCvw1BNm77Vx1WEAi
         wDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVOdjAomzkcJYMgAthO69G0kiY/r0K9/P2d74w84F1c=;
        b=Ex7l1qTSVg7zTdlj4bbBYhYFbwTOZz6AKRmepORHe6A2qFP2Z1K04FLkvjh0avSW8O
         aMgUf797QDsf2f5Xa1863NNE+f1AuHk6/IYwZw5WcwhxNdtkJBcMXcTMuJBLWWLi5DhU
         lXrfNcvAyZnetTDV59sh4rLHIxUI9HaSlS1bOGHvrLD14etl1owv8/CFsZuxz20YxSIF
         RCKE48qhSJ9YZsXf359CwwDVbSLyMfzbVEqQ7t+/FRB8XA7CpGg8xhvtQXyVw4e1JMUl
         aXQc92tzy2lJEgafELuhD0SK4zCNug7Xgr6I3YQ/HUm1RvSNKCTHrHqYl9ml32BNAv0k
         1C/Q==
X-Gm-Message-State: ANhLgQ3b1hb1eYupSWFfK79mIr1KpdnUWARqKoOOn+8A8mwdAbGVJrh/
        G/QPnGuW/6hR75d4xafdrmaBtXuiSxivmw==
X-Google-Smtp-Source: ADFU+vtOwKQjV3gBb+kOX2eWO/BBdWSwLIlbLFDcoJK94UypiIEYKul1Y33KsY5vkXUPMjWNFR4ixw==
X-Received: by 2002:ac8:490c:: with SMTP id e12mr12690572qtq.294.1584110605178;
        Fri, 13 Mar 2020 07:43:25 -0700 (PDT)
Received: from davidb.org (cn-co-b07400e8c3-142422-1.tingfiber.com. [64.98.48.55])
        by smtp.gmail.com with ESMTPSA id 69sm14811679qki.131.2020.03.13.07.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 07:43:24 -0700 (PDT)
Date:   Fri, 13 Mar 2020 08:43:21 -0600
From:   David Brown <davidb@davidb.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Unable to xfsdump/xfsrestore filesystem
Message-ID: <20200313144321.GA162167@davidb.org>
References: <20200303165000.GA33105@davidb.org>
 <20200303221821.GU10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303221821.GU10776@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 09:18:21AM +1100, Dave Chinner wrote:

> > In addition, I get hundreds of these.  They seem to all be related to
> > that same directory.
> > 
> >     xfsrestore: restoring non-directory files
> >     xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/cmake_install.cmake failed: No such file or directory: discarding ino 2833282
> >     xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/asf/common/cmake_install.cmake failed: No such file or directory: discarding ino 2833283
> 
> Yep, this is typical of a dump taken on a live, changing filesystem.
> i.e. This is not an xfsrestore problem but a result of changing
> filesystem structure while xfsdump is running.

This is not the case.  I am creating lvm snapsnots and dumping those
with XFS dump.  Nothing should be changing the filesystem during the
xfsdump.

David
