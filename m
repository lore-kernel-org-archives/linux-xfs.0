Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38000 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbdGUEk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:26 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 15/15] include: remove some unused headers
Date: Thu, 20 Jul 2017 21:38:53 -0700
Message-Id: <20170721043853.364-16-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

test.h and usctest.h aren't used by anything.  Get rid of them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/test.h    | 192 ----------------------------------
 include/usctest.h | 303 ------------------------------------------------------
 2 files changed, 495 deletions(-)
 delete mode 100644 include/test.h
 delete mode 100644 include/usctest.h

diff --git a/include/test.h b/include/test.h
deleted file mode 100644
index 29580dde..00000000
diff --git a/include/usctest.h b/include/usctest.h
deleted file mode 100644
index 193852ff..00000000
-- 
2.13.3

