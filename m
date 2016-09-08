Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbcIHOIE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Sep 2016 10:08:04 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] libxfs: fix up mount check handling
Message-ID: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
Date: Thu, 8 Sep 2016 09:07:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

A 2 patch series to more cleanly handle the disappearance
of ustat() on some platforms, used in platform_check_ismounted()
on Linux.

-Eric
