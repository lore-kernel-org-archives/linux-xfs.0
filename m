Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ACEEB64DC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 19:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjGQTya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjGQTy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 15:54:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDB31702
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 12:54:26 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666edfc50deso2979485b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 12:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1689623666; x=1692215666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xBJ0dZl5RBX8tESkYy9NHojYMRb0pL+oCCTlanYNmPc=;
        b=W+a5a/rM1rXlsuvtFHNcnzz6V+IVXw+Sv8yfARAO7py3RXQYnuIj/frVW+kC1YdGGl
         qI/IbUbIik3Q0DHeObiY3TS6MNCzrTAhf1gaUx1e3hfnbc20+jsGgcVlfsRnh6cV5ZtG
         pPoxI9kmKIo1/vGjMa7qy1FfQtc9j+dFJjAYGgkg2ax0d/Nm8AYwWxFx8lPkWHog8AIk
         wmLikSteiFscLAEeQxNYZv/OaShTHIiAwXevcJ7NTiv15IMbXsWPWTZNc1yK95D36ZTq
         kKQtmnR6jjTJjFyBZxPug7AE0KFYYvY0VsLmaOlt7+tlTEC/Jmm0oYAbVyiymnkECPze
         /88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689623666; x=1692215666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBJ0dZl5RBX8tESkYy9NHojYMRb0pL+oCCTlanYNmPc=;
        b=dZDSpAOAPBBGxu9xNy/P/WAXcDFs9WR6TLhPVmuA51uWqv1dSSTTwFbBEye8/vsVKT
         3Wt8eO+YuNMGdiPM9mTBTTFoZet9gd++7hLrsqRkKEMlD/YITVjMmyQm8WwEZa6XyA5h
         +AgqkSZU6tle9amCr8m4dWvb4y7gwGV8CE121ri8myr9DCoLDwjxTOFrV1MqKK9W5wfq
         +xxqyovP+UEcmGGvkN0NLhULJSFHxLUlmy2zIar+DS1+amHfkwD2KszyvzF5ot/RrFVc
         GjCkNPWXQlwC15UfDxzeM1CLhT5SQ3OJaJTILPV3k0rmMM6A4e4tVxoK6IIQIqx1g1Di
         SXJA==
X-Gm-Message-State: ABy/qLYPIkTUyIZj/5xCprnvtNV+rjd4Z7r1vcaTUUd8oW1BUpDcqXWH
        Eed8POsWYHzpNVSRP5tojKphFySRccvFKC3Wsm4=
X-Google-Smtp-Source: APBJJlEHE3tp7UV9/vXRk8F9BSo9ySkrlk6EzeX6CfL3Tz/L6KNHFna+q1C6pYuY+VJmT1eMIx6HXQ==
X-Received: by 2002:a05:6a20:6a0d:b0:133:17f1:6436 with SMTP id p13-20020a056a206a0d00b0013317f16436mr12400264pzk.19.1689623665996;
        Mon, 17 Jul 2023 12:54:25 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:7a5c])
        by smtp.gmail.com with ESMTPSA id u3-20020a62ed03000000b0064d3a9def35sm160770pfh.188.2023.07.17.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 12:54:25 -0700 (PDT)
Date:   Mon, 17 Jul 2023 12:54:24 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 2/6] xfs: invert the realtime summary cache
Message-ID: <ZLWccEOHmPGyVh4I@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
 <e3ae5bfc7cd4b640e83a25f001169d4ae50d797a.1687296675.git.osandov@osandov.com>
 <20230712224001.GV108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712224001.GV108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 03:40:01PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 02:32:12PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
> > added a cache of the minimum level of the realtime summary that has any
> > free extents. However, it turns out that the _maximum_ level is more
> > useful for upcoming optimizations, and basically equivalent for the
> > existing usage. So, let's change the meaning of the cache to be the
> > maximum level + 1, or 0 if there are no free extents.
> 
> Hmm.  If I'm reading xfs_rtmodify_summary_int right, m_rsum_cache[b] now
> tells us the maximum log2(length) of the free extents starting in
> rtbitmap block b?
> 
> IOWs, let's say the cache contents are:
> 
> {2, 3, 2, 15, 8}
> 
> Someone asks for a 400rtx (realtime extent) allocation, so we want to
> find a free space of at least magnitude floor(log2(400)) == 8.
> 
> The cache tells us that there aren't any free extents longer than 2^1
> blocks in rtbitmap blocks 0 and 2; longer than 2^2 blocks in rtbmp block
> 1; longer than 2^7 blocks in rtbmp block 4; nor longer than 2^14 blocks
> in rtbmp block 3?

There's a potential for an off-by-one bug here, so just to make sure
we're saying the same thing: the realtime summary for level n contains
the number of free extents starting in a bitmap block such that
floor(log2(size_in_realtime_extents)) == n. The maximum size of a free
extent in level n is therefore 2^(n + 1) - 1 realtime extents.

So in your example, the cache is telling us that realtime bitmap blocks
0 and 2 don't have anything free in levels 2 or above, and therefore
don't have any free extents longer than _or equal to_ 2^2.

I'll try to reword the commit message and comments to make this
unambiguous.
