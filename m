Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:50941 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbeD3Hqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 03:46:55 -0400
Received: by mail-wm0-f49.google.com with SMTP id t11so11540183wmt.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 00:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
References: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 30 Apr 2018 09:46:33 +0200
Message-ID: <CACj3i732Fzn-x2bZV7XBDGwF5JrgmVEE3_5AaSf-6Pe1TpQa3w@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: do not use 'function' keyword
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 3:15 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> It was pointed out on irc that fsck.xfs uses the 'function' keyword
> although it invokes /bin/sh - 'function' is a bashism.  It's not needed
> here, so just remove it.
>

Ah, thanks.

Jan
