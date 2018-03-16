Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56834 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbeCPFVv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Mar 2018 01:21:51 -0400
From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/2] workqueue: add missing pthreads header
Date: Fri, 16 Mar 2018 07:21:35 +0200
Message-Id: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>

Fix the following build failure with musl libc:

In file included from read_verify.c:25:0:
../include/workqueue.h:39:2: error: unknown type name 'pthread_t'
  pthread_t  *threads;
  ^~~~~~~~~
../include/workqueue.h:42:2: error: unknown type name 'pthread_mutex_t'
  pthread_mutex_t  lock;
  ^~~~~~~~~~~~~~~
../include/workqueue.h:43:2: error: unknown type name 'pthread_cond_t'
  pthread_cond_t  wakeup;
  ^~~~~~~~~~~~~~

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/workqueue.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/workqueue.h b/include/workqueue.h
index b4b3541701df..edb2f8ac5991 100644
--- a/include/workqueue.h
+++ b/include/workqueue.h
@@ -22,6 +22,8 @@
 #ifndef	_WORKQUEUE_H_
 #define	_WORKQUEUE_H_
 
+#include <pthread.h>
+
 struct workqueue;
 
 typedef void workqueue_func_t(struct workqueue *wq, uint32_t index, void *arg);
-- 
2.16.2

