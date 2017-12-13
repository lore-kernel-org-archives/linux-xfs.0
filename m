Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:39044 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752811AbdLMQQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 11:16:15 -0500
Received: by mail-lf0-f49.google.com with SMTP id l81so3276595lfl.6
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 08:16:15 -0800 (PST)
Received: from odin.usersys.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l136sm391087lfb.46.2017.12.13.08.16.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Dec 2017 08:16:13 -0800 (PST)
Date: Wed, 13 Dec 2017 17:16:11 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: fallocate behavior on -ENOSPC for blocks past EOF
Message-ID: <20171213161611.53oavmzhnsum2fqc@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We have talked a bit about it on irc before but iirc we didn't end on any
conclusion about it.

Current fallocate behavior on XFS in case it hits -ENOSPC in the middle of the
reservation is kind of weird now when these new blocks are allocated past EOF.

We end up not changing the i_size to match the partial blocks allocated even if
fallocate is not called with KEEP_SIZE.

Such behavior is confusing some users of fallocate, and I've been talking to
Eric if wouldn't be better to update the i_size to match the partially allocated
blocks IF KEEP_SIZE has not been used.

I know though that fallocate behavior is kind of undefined in this case, but I
wonder if is there anything we could agree to improve to make it less confusing
for fallocate users, or at least agree if this is the behavior we want in XFS.

Maybe is worth to mention though, that by now, we release any unwritten extent
past EOF at certain points in the code (/me don't remember exactly where by
now).

I didn't have time to come back to this issue before, so, sorry about the lack
of more details, but let me know if anybody needs more specific details about
this and I'll get more data.

Cheers



-- 
Carlos
