Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr013msb.fastweb.it ([85.18.95.104]:39992 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbeBZV2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 16:28:39 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Feb 2018 22:28:37 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <CAOQ4uxh5OrWyD9DddC7W9UYPaYP1ON1CzKUB=R+8midTFsa+bg@mail.gmail.com>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <CAOQ4uxh5OrWyD9DddC7W9UYPaYP1ON1CzKUB=R+8midTFsa+bg@mail.gmail.com>
Message-ID: <00a65dbb1d14b47fb92409db5e7d1e6e@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, g.danti@assyoma.it

Il 26-02-2018 21:29 Amir Goldstein ha scritto:
> I was also expecting dirty data to be lost, but according to Darrick 
> that is
> not the case for page cache dirty data, although in all likelyhook, 
> your VM
> is using direct IO to write to image file.

Yeah, it was better than expected. For some VM I use Qemu/KVM writeback 
policy rather than "none"/O_DIRECT, so the fact that host-side dirty 
data will not be lost when reflinking is a pleasant surprise.

> I think your use case is interesting and this is definitely the right 
> place
> to ask these questions.

Great ;)


-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
