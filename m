Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:33378 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932211AbdCFOZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 09:25:40 -0500
Received: by mail-it0-f42.google.com with SMTP id w124so2178792itb.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 06:25:34 -0800 (PST)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 6 Mar 2017 15:25:03 +0100
Message-ID: <CACj3i72avXdkrQdfGnfeRpnOoPo+bcBMForczMt_dnK-ZXQbkg@mail.gmail.com>
Subject: xfstests and (automated) workflow?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi guys,

II decided to streamline and automate some things for me with testing
xfs, but as I worked on it, I realise that surely I'm not the first
one to do that. So I would like to ask you, can you share your tips
and tricks? :-)

What I began to work at is a small suite of scripts to deploy a docker
container (could be changed for a VM) which compiles my local version
of xfsprogs and xfstests, runs it, and if I specify multiple
revisions, it does it for every of the revisions and then tells me
which test results changed between the revisions. I know the
comparison of failures between runs can be done with
tools/compare-failures. It doesn't detect a change in "not run"
though, which I would like to detect too.

Are you using anything like this you can share?

Thanks,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
