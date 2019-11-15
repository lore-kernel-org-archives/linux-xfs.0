Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA255C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B3620730
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCDxRt1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfKOTLg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 14:11:36 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35832 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfKOTLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 14:11:35 -0500
Received: by mail-lj1-f194.google.com with SMTP id r7so11827074ljg.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 11:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Wm7FSDztVRcbXu9v/VF4qYAiGBoHbbmZneKM0FxpMuM=;
        b=dCDxRt1Xk7w/nj+15HvxpWBXMfucbIdWLehaEo6Vy0ltFqWp5iMfSpg2Fkc16j0B1D
         WWhgNRpP0oyKM8ktlyhi9PrhlDeK0BWhxtrsaKpV4VTEyX/rb5/S1uQnzHOyDPy5iDQc
         gAhBjdvSkAIeBdpZR2MjaHx/HqIRtEidjuyVshgPiFaXRK57MG4i3F+X41MIZCsY56aw
         f3YYFo1NXF+KBQFK6PFtYZfFMzVjKj+r8TUy83WmhMsmj+Vr5NFAAOkfw5IO/2Hp9Hvx
         +oUioSUsB8YlATQsDLqaPrhMBAi1Ll7pbq7lNjnV63R9ZNC2bszMlsill+H0U28S6QIW
         9ueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Wm7FSDztVRcbXu9v/VF4qYAiGBoHbbmZneKM0FxpMuM=;
        b=slR+qPJKWOk8xhiyqHjoUnKZSg61pzHbl5XEcz2n+pxVxp1lP2EhHh1wygp12CtgRi
         pfyoA0kdywpmQ1EAZQlMk8XbD1XgONQE6upKuw8/cR9Sh6k4CjAZki5GKe63FfeBVwnR
         pdWSwiN7AAhnBgmKoBGPacBgMRvQqMTuGO4RPbyJ71LE+I3Y5dQQbuItWjNbiEfdWMdu
         GH8n6J4gNeAjVQYRN7hha3ShEtvb/I0tnpR2Fm83ONFkhAZWxVD02mbZI770zmmd4WW0
         vgj561EKtHpOCFa8sJ8uiW2YUaTm4EsYZ0/NDXgQuwOaRBRTGomFgm/DyF7cf0QS5rEh
         UQOA==
X-Gm-Message-State: APjAAAXDukk7E2DwqNnPqYxX25D44XwPo2OY/anegw3cGjUZyPZ9AAfO
        XaHUEbbURZeFva6XnN2EsuULP+Ciq/NYDxQjVPEHrMfm
X-Google-Smtp-Source: APXvYqxyGu0kQuky0/NUyGj84J/I2VYxRv62DyrR0cfX5RQNOEi8McsWTBMyKoslOQbEFL89Py+SWVlHRaV0FOQr7zI=
X-Received: by 2002:a2e:9a8f:: with SMTP id p15mr12508787lji.148.1573845093243;
 Fri, 15 Nov 2019 11:11:33 -0800 (PST)
MIME-Version: 1.0
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
In-Reply-To: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
From:   Andrew Carr <andrewlanecarr@gmail.com>
Date:   Fri, 15 Nov 2019 14:11:22 -0500
Message-ID: <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
Subject: Fwd: XFS Memory allocation deadlock in kmem_alloc
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

This list has recommended enabling stack traces to determine the root
cause of issues with XFS deadlocks occurring in Centos 7.7
(3.10.0-1062).

Based on what was recommended by Eric Sandeen, we have tried updating
the following files to generate XFS stack traces:

# echo 11 > /proc/sys/fs/xfs/error_level

And

# echo 3 > /proc/sys/fs/xfs/error_level

But no stack traces are printed to dmesg.  I was thinking of
re-compiling the kernel with debug flags enabled.  Do you think this
is necessary?

Thanks so much for your time and keep up the good work!

Sincerely,
--
Andrew Carr | Enterprise Architect
Rogue Wave Software, Inc.
Innovate with Confidence
P 720.295.8044
www.roguewave.com | andrew.carr@roguewave.com


--
With Regards,
Andrew Carr
