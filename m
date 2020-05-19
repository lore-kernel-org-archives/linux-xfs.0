Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D29C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 15:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C25FB207D8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589903970;
	bh=EChIuRDHBE2fP/nhZePuBoCI4yW9gOzMTOOZxaha+Mc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ds3Jdq4Xo6bVZMBw1ZSV+cpj2a3UTJd5Iu3k5AXGTaoxmWxbCj3gbipu2wmHQTRy/
	 xDWh2NsdU2o2jVzgCapr+cKyfT7RnlzHTTNggVetXaoeyNV4W3Xvq0PRL/lfiXsSVR
	 v1liBGZZntrCcBhqgWwJ3eo4A4Tpg9OgiTPvauHM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgESP71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 11:59:27 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38560 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgESP70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 11:59:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id o13so261770otl.5;
        Tue, 19 May 2020 08:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EChIuRDHBE2fP/nhZePuBoCI4yW9gOzMTOOZxaha+Mc=;
        b=SwM+hS/x8u0hUuAlW6DcoLHI26AvrHXuvEh7EVnW4gmL0AMVtcizK/+LgItB78y+a/
         gu9DWmhRYqWzA5YxdJgHW6hQo2fakviDxtwIDtteA62Z5kA2mOMnv+zlCCC+TPoZbqRE
         Up2WjD3VCW4Fxq/vFUwZmkCJMF+nAHWqD/XI0w8r4AJeU9fEXZJVwbT2uCGyWGqyZAEI
         RgMhN/MXUZseduToSS0dWXqMmKiCS4GCBbfxMiE3/sHzAHL0cIIyV8DXrCMjU2WNOpS9
         twTgNOi6TjbRDytnheagoM83+o/25RzkoJH7o27I+THwkOK2SNhbnJUU+swCQ/PN5tlj
         9YiQ==
X-Gm-Message-State: AOAM532s8yaqL1WBligdJe2nUn1Q/5MPGp3h6Xq3aX6/7zU0gOVaC/Fk
        Th67XLf8tpjlqHieruTrwjE3J4ZT+N2Uv11qI2U=
X-Google-Smtp-Source: ABdhPJwAtkbCgsui0+h1xBcvCEqFP0J6q3SWQt/hKKidr/kXNdClt4Q1ZYDyL2hyzmh5V8EvoEwCGPA6GQfLuvx6Sr0=
X-Received: by 2002:a05:6830:10ce:: with SMTP id z14mr15933980oto.118.1589903966068;
 Tue, 19 May 2020 08:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200507080456.069724962@linux.com> <20200507080650.439636033@linux.com>
In-Reply-To: <20200507080650.439636033@linux.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 19 May 2020 17:59:15 +0200
Message-ID: <CAJZ5v0jnfeAQ4JDz+BTZp8P98h6emTizGWLYNL_QtbQ=3Nw03Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] hibernate: restrict writes to the snapshot device
To:     Domenico Andreoli <domenico.andreoli@linux.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Len Brown <len.brown@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It would be better to paste the patch instead of attaching it.

Anyway, note that the snapshot special device is not the target block
device for saving the image, so it would be good to avoid that
confusion in the naming.

I.e. I would rename is_hibernate_snapshot_dev() to something like
is_hibernate_image_dev() or is_hibernate_resume_dev() (for consistency
with the resume= kernel command line parameter name).

Thanks!
