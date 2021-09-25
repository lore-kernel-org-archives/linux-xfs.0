Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F174CC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 02:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7D860EE7
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 02:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347282AbhIYCST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 22:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343760AbhIYCST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 22:18:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BA0C061571;
        Fri, 24 Sep 2021 19:16:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w19so10407652pfn.12;
        Fri, 24 Sep 2021 19:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KUE5uliHgQSz+W6OoczSy6j/pQcC1fX9twvbX7G/f9A=;
        b=RzG5JAXjYeb25XGQTSaj998+yrmmkOU8udleo9PeOjjULMZwsV7c3+ev4kIIYNW97R
         KBweX8EZeU0XeFblZ7Xolw+z3yNqfv1XsHAGBDrCotscfieM431chguBIzTY2axLiDG/
         GYB5unJeMUwoj5Y+fP65PqVK0qKez0k6Lphy4zgeDjXFSyzfRA9w8jBBW1CviB2FXFpH
         hRYJBkkzAZs0nmvHNXg+DO1rlR9Ou8NpSG36XugeVupxE9ITaGIpdABlsRQVD+4LkMCE
         +s79tHe1Hg+JZcAEXgGxnkNqDphiKl17xpnUMyPWV6s1MavImb+3hglLdja6yipQ6OM7
         T0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KUE5uliHgQSz+W6OoczSy6j/pQcC1fX9twvbX7G/f9A=;
        b=RVG58enSJWJkEPLXRKrSo0yW8Wr8Ym3XWtKs5Ry/GqOeydF6nb5hI7hqOxUvgx4AZW
         6S/DQnLKSnkeDFNXADTQHFwYFAfmncWu3Hyu6W4VgJ8YpfXV3w9Lqrac+zo2Z7jFbMXT
         ey6QkjsSSs/1zFYWwaBxXmHWQElJcvqM96ZEouLL1aQkGk4ZTqQ1nwpndefzETqGCb3V
         +EuAZCVXvPaoiKwgDjgVUOD2266CztEhhtlcxo+tgjdRkI0JSrxzblDJsVNxLWgb5pKN
         IWu41Fnk4LKsULWOBqHdzwpyxIzfy+awh30mh2I9v62CXm5pgvd+aUtF1ItS31i0ZRwc
         E6tA==
X-Gm-Message-State: AOAM530x92XVBdGE9x4+t1wKQIvmVyCmxEicLUSmlMttEw6hwshJer8P
        YCqve4/nx8tyKVAPuOK6uqE=
X-Google-Smtp-Source: ABdhPJz9qDtI8Rt1jEkDRRLpydnqi3owtC6V2O+F6zBttQNaz/2noMS7iYDEb/f1XgCkSFFzLjDf1w==
X-Received: by 2002:a63:1f10:: with SMTP id f16mr6284338pgf.423.1632536205017;
        Fri, 24 Sep 2021 19:16:45 -0700 (PDT)
Received: from nuc10 (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id x21sm10249866pfa.186.2021.09.24.19.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 19:16:44 -0700 (PDT)
Date:   Fri, 24 Sep 2021 19:16:42 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Fengfei Xi <xi.fengfei@h3c.com>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tian.xianting@h3c.com
Subject: Re: [PATCH] xfs: fix system crash caused by null bp->b_pages
Message-ID: <YU6GioPsUlVXbtwQ@nuc10>
References: <20201224095142.7201-1-xi.fengfei@h3c.com>
 <63d75865-84c6-0f76-81a2-058f4cad1d84@sandeen.net>
 <YUphLS+pXoVwPxMz@nuc10>
 <20210922014804.GQ1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210922014804.GQ1756565@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Sep 22, 2021 at 11:48:04AM +1000, Dave Chinner wrote:
> On Tue, Sep 21, 2021 at 03:48:13PM -0700, Rustam Kovhaev wrote:
> > Hi Fengfei, Eric,
> > 
> > On Thu, Dec 24, 2020 at 01:35:32PM -0600, Eric Sandeen wrote:
> > > On 12/24/20 3:51 AM, Fengfei Xi wrote:
> > > > We have encountered the following problems several times:
> > > >     1、A raid slot or hardware problem causes block device loss.
> > > >     2、Continue to issue IO requests to the problematic block device.
> > > >     3、The system possibly crash after a few hours.
> > > 
> > > What kernel is this on?
> > > 
> > 
> > I have a customer that recently hit this issue on 4.12.14-122.74
> > SLE12-SP5 kernel.
> 
> I think need to engage SuSE support and engineering, then, as this
> is not a kernel supported by upstream devs. I'd be saying the same
> thing if this was an RHEL frankenkernel, too.
> 

roger that, should not be a problem, thank you!

