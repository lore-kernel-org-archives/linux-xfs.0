Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166BEEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 00:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjF1AId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 20:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjF1AIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 20:08:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE6213D
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 17:08:30 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-666e916b880so2991502b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 17:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687910910; x=1690502910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+PmLmbJJFOA4foSIcwkNrzJQ/yoACiI201ItVcq+fEA=;
        b=p4X/xYME2KpltrYdssIGRJmbqHnnFHeatOj54Xe0xfhQEfJX8u7i3ozZN1Q4VhxYgO
         ogINku94P6kjR5LM6V1FRIwcjFxWp6p+iLa+pY154m/HCXU13O7H4fvh2Uihfu3Hi3y7
         wlvQcZd/XIPfwwqCkiYXMAtC/tBXcOUOIvwPA5Ze0WaoQ4gqJ1SNZfWOjqfdFsiVnAIA
         tT6OV+eZWVWU1jqZnSVAwUZvktCvy3T0325KtClz8/wqmSS/4U8UKt1G2TGjmoTnacBV
         ODDO3GcIrfGIo4oirVUaB9a0GCeYXPAHqYKYvMEwgQ0g7olKljgks6qCb11a3hh99tQn
         zbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687910910; x=1690502910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PmLmbJJFOA4foSIcwkNrzJQ/yoACiI201ItVcq+fEA=;
        b=AWfYQQIX/mB2f6hw4BbVT8jSy74YaXxGHF/C5cAfGuJcRqbBRJ7vHJFuAeZxLv+ebm
         M11UQkAWRlmJXdKDuzV9jVvFKVf+pqBa8vV7yAqWMVLiNPCBOZGd/ovxmDdTM69G+d+h
         r+A3xUv0MwycIWjsCOhr0ABibicPLon6i1EaybGvV0ZSjHepyoIa/RAOY8LVMDNRvHU+
         iJZCWfX/PqZjq0x7ajob+QsGfZIm4ZH+pbX25aCclVBZBG+NsWOi3jvdqZ7Xdg3YogYz
         KyPY+5emCT5ezEFGKINAdGkjBps/DEMjhklpplZXKGewcSSke96e5seKAFzElNU1XYiv
         DCTg==
X-Gm-Message-State: AC+VfDwzNMDMVnx7EAqmwRNwbBC44Vok10ybIQaFzVHT3vQYUOmgNLSK
        OzSsI59c8H2EkWhUr+vht/hHgw==
X-Google-Smtp-Source: ACHHUZ73zFpYEzo1c1bJ/memphS0176aJhX5Q/6jiRaqDfqXlNQybnYwpVy/TRPuW4z/LL5g8PyUfA==
X-Received: by 2002:a05:6a00:809:b0:66a:2ff1:dee4 with SMTP id m9-20020a056a00080900b0066a2ff1dee4mr18376338pfk.2.1687910909968;
        Tue, 27 Jun 2023 17:08:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id s11-20020a63dc0b000000b0053031f7a367sm6311639pgg.85.2023.06.27.17.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:08:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEIjS-00H1P8-2A;
        Wed, 28 Jun 2023 10:08:26 +1000
Date:   Wed, 28 Jun 2023 10:08:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v25.0 0/5] xfs: online repair of AG btrees
Message-ID: <ZJt5+hUrfQ5rq8mj@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:29:58PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Now that we've spent a lot of time reworking common code in online fsck,
> we're ready to start rebuilding the AG space btrees.  This series
> implements repair functions for the free space, inode, and refcount
> btrees.  Rebuilding the reverse mapping btree is much more intense and
> is left for a subsequent patchset.  The fstests counterpart of this
> patchset implements stress testing of repair.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

This all looks fairly sane. The only concerns I have are the icache
lookup bits I commented on. Hence for everything but that patch,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.

-- 
Dave Chinner
david@fromorbit.com
