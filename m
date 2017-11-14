Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755105AbdKNMd2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:33:28 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 0/3] fix failures caused by mount error msg change in util-linux v2.30
Date: Tue, 14 Nov 2017 20:33:07 +0800
Message-Id: <20171114123310.25286-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

util-linux v2.30 changed mount error message again and caused several
tests to fail (reported by Misono Tomohiro, thanks!), this is mainly due
to two util-linux commits in v2.30-rc1

6dede2f2f7c5 libmount: support MS_RDONLY on write-protected devices
ea848180dd34 libmount: add mnt_context_get_excode()

This patchset introduced _filter_ending_dot, _filter_error_mount and
_filter_busy_mount and improved _filter_ro_mount to deal with all these
output differences between old and new util-linux versions.

I've tested and confirmed generic/050, xfs/005 and overlay/03[567] all
passed with both old and new util-linux. xfs/333 is always _notrun
because there's no realtime-rmapbt support yet.

Perhaps there're better and cleaner ways to fix the problems, please
help review and advise, thanks!

Eryu

v2:
- remove not-needed _filter_scratch from tests

Eryu Guan (3):
  fstests: filter mount error message for EUCLEAN and ESTALE
  overlay/036: filter busy mount message
  fstests: filter readonly mount error messages

 common/filter         | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/generic/050     |  8 +++---
 tests/generic/050.out |  8 +++---
 tests/overlay/035     |  9 +++++--
 tests/overlay/036     |  4 +--
 tests/overlay/036.out |  4 +--
 tests/overlay/037     |  4 +--
 tests/overlay/037.out |  4 +--
 tests/xfs/005         |  7 +-----
 tests/xfs/333         |  2 +-
 tests/xfs/333.out     |  2 +-
 11 files changed, 95 insertions(+), 27 deletions(-)

-- 
2.13.6

