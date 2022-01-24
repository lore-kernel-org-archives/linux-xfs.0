Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C8EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 04:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1315213AbiAYEQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 23:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1318607AbiAYDGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 22:06:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B963C061A81;
        Mon, 24 Jan 2022 15:21:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n16-20020a17090a091000b001b46196d572so717381pjn.5;
        Mon, 24 Jan 2022 15:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9eUsbBSutM1lBuLU7dAKTs07j7eGXAZ+4bo5/dxVc74=;
        b=MgBud9+uVemvmsL8Z6AceYLsDylgGBN06Nv8AhlbDdkc6YAvatV4TS+c0RoN2zxGGZ
         dWc5geZpWwBGz0CnJ/8hg25SqcH5wJ8Z0J/jcBEFFjq2WrKBWk5q40C5lRONTB/yXT9H
         O1JVRcaVN8aEdWZDisTayXA7hOudhOk96puqJPROeCkzDyxDFEsTLKJqJh99Ve2mg5N+
         NVLgxTDUi4khQ8Soo/IRZeNqNpMpBZvsYCzswmhL17rAnt0CSDlHnE+oddMYfj3sR1SX
         Kqt9zbejJLbM5KsFmoxcdbnj39mCakgvMkI7lD3QTNm+NxL+gSrYSvJ8ZydcEVqm70Y7
         9HPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9eUsbBSutM1lBuLU7dAKTs07j7eGXAZ+4bo5/dxVc74=;
        b=lLAHtnZ8ENP1GBqDPXS0yOcRZIrY+9IimJTOVEYDt7rgeh2jOHWe7EjK3FrkGzM+vs
         mzvlGhZ53WOCLXTNKvJUQ6wb9H+bI57zz1omVSgk1OtWXNlnhpb8RcQ3hM45qABEd5vm
         eqF6HPOlDrWE0NxdIyqPdgKTMJGrp/l5yKHzIB2pKDSf66/hRMNZ4AZWzrj7c/oWi5pm
         +mU7TYGTzIPyH9pMFEAMbmutWbh00wIrEAs7OB0LeDEwXl40I/ZptmGOJdtPn/vVUJK0
         bvM8dwNSpcRx+5xEZLFeTzm05biGJDWlteKnOiAMEdxP5jItfVLow3ogMPd75X24Ity2
         klWQ==
X-Gm-Message-State: AOAM533vAFnaFZ8JfFMZ6ZJG9xCCT5MgKswo5tbbgrk9GTNNTScv084A
        KB/oE1gpFNPo/ihewxwKEAT1RiW4p97/Rw==
X-Google-Smtp-Source: ABdhPJxXblgfhhTrKXc/lvfVBUzKbQ0WSaSc4mRirdkAGKVGCIRrJ4Bv3gDgvdgK1K5mRvoABSdWFw==
X-Received: by 2002:a17:902:d883:b0:14a:4ba5:6e72 with SMTP id b3-20020a170902d88300b0014a4ba56e72mr16784773plz.27.1643066468049;
        Mon, 24 Jan 2022 15:21:08 -0800 (PST)
Received: from google.com ([2601:647:4701:18d0:ec80:a45b:502a:bda8])
        by smtp.gmail.com with ESMTPSA id nu15sm400304pjb.5.2022.01.24.15.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 15:21:07 -0800 (PST)
Date:   Mon, 24 Jan 2022 15:21:05 -0800
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/273: use _get_file_block_size
Message-ID: <Ye8zQ4d1FAIvk4Oy@google.com>
References: <20220124183735.GJ13563@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124183735.GJ13563@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Applied and confirmed this fixes generic/273 for realtime 28k
extent sizes for me.

Reviewed-by: Leah Rumancik <leah.rumancik@gmail.com>
