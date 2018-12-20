Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41712 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731843AbeLTOe1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 09:34:27 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DF9FD87C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 08:34:07 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: RFC: deprecate mkfs.xfs protofile functionality
Message-ID: <e3b338cb-33d0-04d0-c14c-7b06a7b924c9@sandeen.net>
Date: Thu, 20 Dec 2018 08:34:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

I'd like to deprecate and eventually remove the protofile functionality
in mkfs.xfs, because it's not well tested code which is really a special
snowflake in the codebase that adds complexity.  And as far as I know,
nobody uses it.

If I'm wrong though, speak up now.  Is anybody using protofiles?

(If you don't know what a protofile is, then you're not using it.
And let's not turn this into a "well I could think of a way to use it"
discussion, because it's been there for a couple decades and if you're
not using it /yet/ ... unless there really is some new usecase on the
horizon which would clearly depend on it.)

Thanks,
-Eric
