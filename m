Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 12:28:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6HJSWTM019655
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:28:32 -0700
Received: from el-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89073E52A7B
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:29:40 -0700 (PDT)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.177]) by cuda.sgi.com with ESMTP id DIrDT6QTGCC0ZO0C for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:29:40 -0700 (PDT)
Received: by el-out-1112.google.com with SMTP id v27so30663ele.23
        for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 12:29:39 -0700 (PDT)
Message-ID: <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:29:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
In-Reply-To: <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com>
	 <487F980F.7070708@redhat.com>
	 <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Tim Shimmin <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>

On Thu, Jul 17, 2008 at 9:18 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Thanks, you are right. I have adjusted my configuration, but I am
> still able to produce this:
>
> BUG: unable to handle kernel paging request at b62a66e0
> IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490

FWIW, this is fs/xfs/xfs_alloc.c:1817:

        if (!pag->pagf_init) {


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
