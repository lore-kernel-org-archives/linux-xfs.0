Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27E3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 05:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbiK2Fgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 00:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiK2Fgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 00:36:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1393F2CDCD
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:36:41 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h193so12006039pgc.10
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wn0b/0uTHyl5PiIDC0soTq3yDEII0DnvPYhQG1aBNQw=;
        b=D7D7mFkYScb8tvzOXHnJ9V3Yw7Z6rNUOuRgks8bxSzYBgmcfRIIgfEo7b9DeVKKUVP
         +VdeVXO1hskC58oGCAF8wmzYX3sLMq73TH4Z3ZzlRhrOV0ApKR86wwLlv734nromrdgW
         QcsmiGVuSVAujvhu7U9aBEDeWW2qlYTYc6NDKYq9Oscdwps4EA6qxaVFibMePoC7L8O1
         FmHCcoWZU8au5dAV5RCjlGdA0mWXPk8UpewTbFBM3hEMrc3bxAJA/LZFSzIbHmvX+xkW
         pyk8EWqC9dUrfONOEisiTADz6YfP1UnayAj92XHTrBwPpoKjoEjIUvlG9zyNcTohzFF9
         hQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wn0b/0uTHyl5PiIDC0soTq3yDEII0DnvPYhQG1aBNQw=;
        b=jrbaSFDYF9GNlv19sY9CHvnTM83p8CiR1toWx3N0yZgGMcX7ldaX634V3YEbGq0Cg9
         65yvXlcBbdM80dCHhqCv3Ry179uG9TMRXbZM8/PFI7hIjGByiSJZsVcUGNWSLEAjbTv5
         UT5wv9uzfOOlsgRefAA6XZnMjDf5hF+HzoKp5YUQB4fg/hygdFbJmYbQx9ZjKWIkY6PD
         8bPfa3xvd0ogDGmkbd3g8pnLKkOUB4uKHiV33j5wuqqdY2vsx8y7+ogq1YCQ05yPuiXg
         /uaLRbJN2MnPwu65KGO2rrmf8rXgRyVZyuYK30zSotDD5CVeDTYBeyhjFnAV0HnHniPu
         7fmw==
X-Gm-Message-State: ANoB5pnNV4O2TnKufsE+Zh8GSLfZCjYJd1bRXklZFUK0OXe7JlVGGk0f
        MSQUE3Qf27rHrLM8EyL7OfNM9eHOclik6A==
X-Google-Smtp-Source: AA0mqf7AFnCyvigMJw4SE5a2icDe0GR0v90OYLXa3HNh+w1quFmI6+xmPTv3A/JkabndItXEzwexYg==
X-Received: by 2002:a63:4b41:0:b0:477:fbed:369b with SMTP id k1-20020a634b41000000b00477fbed369bmr12934632pgl.57.1669700200568;
        Mon, 28 Nov 2022 21:36:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b00188fce6e8absm9672303plk.280.2022.11.28.21.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:36:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oztIL-002JbM-3Z; Tue, 29 Nov 2022 16:36:37 +1100
Date:   Tue, 29 Nov 2022 16:36:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: shut up -Wuninitialized in xfsaild_push
Message-ID: <20221129053637.GC3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930917525.2061853.17523624187254825450.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166930917525.2061853.17523624187254825450.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:35AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> -Wuninitialized complains about @target in xfsaild_push being
> uninitialized in the case where the waitqueue is active but there is no
> last item in the AIL to wait for.  I /think/ it should never be the case
> that the subsequent xfs_trans_ail_cursor_first returns a log item and
> hence we'll never end up at XFS_LSN_CMP, but let's make this explicit.

If xfs_ail_max() returns NULL, then xfs_trans_ail_cursor_first()
must return NULL as the AIL is empty. So we always jump out of the
code in that case, and never use an uninitialised target value.
Older compilers (gcc-11) don't complain about target being used
uninitialised, only newer, "smarter" versions.

FWIW, the patchset I have that reworks the AIL push
target/wakeup/grant head accounting completely reworks this target
code[1], so in the mean time doing this to shut up the compiler
warnings is fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

[1] https://lore.kernel.org/linux-xfs/20220809230353.3353059-1-david@fromorbit.com/

-- 
Dave Chinner
david@fromorbit.com
