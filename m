Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33617 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752635AbdDDIya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 04:54:30 -0400
Received: by mail-vk0-f42.google.com with SMTP id d188so165927576vka.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2017 01:54:30 -0700 (PDT)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 4 Apr 2017 10:54:09 +0200
Message-ID: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
Subject: [xfsprogs] Do we need so many data types for user input?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi guys,

as I'm still working on the mkfs changes, there is an opportunity to
clean up data types a bit. Right now, we are saving user input into
long long, bool, uint64, int, uint and string. Custom data types are
not saved into directly but such values are usually a result of a
computation.

I can't find any place (in the user-input section) where would we
really need anything else except uint64 and string. Some examples:

* We load an option into an int and then raise an error if it is a
negative number
* Or we even allow for 0, 1 (and 2) only
* It seems that the only place where we are not limiting the int
values immediately are logarithmic options. But unless my math
knowledge failed me, only complex logarithm is defined for negative
numbers and I really doubt we want to have "3+4.5 i" as blocksize...
;-)

Simply stated, signed values seem to be useless here. And at the end
of the day, we are converting all numbers into unsigned in one part of
the parsing anyway, so I don't see how such a change could change any
behaviour.

So what do you think, can I remove the other types in user-input part
of the code and save all numbers as uint64?

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
