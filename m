Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752236AbcLGNd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:33:59 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F4B364DC
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:54 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 13/22] mkfs: remove zeroed items from conflicts declaration
Date: Wed,  7 Dec 2016 14:27:20 +0100
Message-Id: <1481117249-21273-14-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

opts is a global array of structs, so it is already zeroed. No need
for explicit zeros on items unless we want to highlight the value.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 200 --------------------------------------------------------
 1 file changed, 200 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b0e5d75..61caceb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -239,10 +239,6 @@ struct opt_params {
 			{ .index = B_LOG,
 			  .conflicts = { {.opt = OPT_B,
 					  .subopt = B_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE_LOG,
@@ -254,10 +250,6 @@ struct opt_params {
 			  .is_power_2 = true,
 			  .conflicts = { {.opt = OPT_B,
 					  .subopt = B_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_BLOCKSIZE,
@@ -291,10 +283,6 @@ struct opt_params {
 			{ .index = D_AGCOUNT,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_AGSIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 1,
@@ -321,24 +309,12 @@ struct opt_params {
 			{ .index = D_SUNIT,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_NOALIGN,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SU,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SW,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -348,24 +324,12 @@ struct opt_params {
 			{ .index = D_SWIDTH,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_NOALIGN,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SU,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SW,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -375,10 +339,6 @@ struct opt_params {
 			{ .index = D_AGSIZE,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_AGCOUNT,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -389,24 +349,12 @@ struct opt_params {
 			{ .index = D_SU,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_NOALIGN,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SUNIT,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SWIDTH,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -417,24 +365,12 @@ struct opt_params {
 			{ .index = D_SW,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_NOALIGN,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SUNIT,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SWIDTH,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -444,10 +380,6 @@ struct opt_params {
 			{ .index = D_SECTLOG,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_SECTSIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
@@ -457,10 +389,6 @@ struct opt_params {
 			{ .index = D_SECTSIZE,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_SECTLOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -472,31 +400,15 @@ struct opt_params {
 			{ .index = D_NOALIGN,
 			  .conflicts = { {.opt = OPT_D,
 					  .subopt = D_SU,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SW,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SUNIT,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_D,
 					  .subopt = D_SWIDTH,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -555,17 +467,9 @@ struct opt_params {
 			{ .index = I_LOG,
 			  .conflicts = { {.opt = OPT_I,
 					  .subopt = I_PERBLOCK,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_I,
 					  .subopt = I_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_DINODE_MIN_LOG,
@@ -581,17 +485,9 @@ struct opt_params {
 			{ .index = I_PERBLOCK,
 			  .conflicts = { {.opt = OPT_I,
 					  .subopt = I_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_I,
 					  .subopt = I_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
@@ -602,17 +498,9 @@ struct opt_params {
 			{ .index = I_SIZE,
 			  .conflicts = { {.opt = OPT_I,
 					  .subopt = I_PERBLOCK,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_I,
 					  .subopt = I_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .is_power_2 = true,
@@ -687,10 +575,6 @@ struct opt_params {
 			{ .index = L_AGNUM,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_DEV,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -700,17 +584,9 @@ struct opt_params {
 			{ .index = L_INTERNAL,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_FILE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_L,
 					  .subopt = L_DEV,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -741,10 +617,6 @@ struct opt_params {
 			{ .index = L_SUNIT,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SU,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 1,
@@ -754,10 +626,6 @@ struct opt_params {
 			{ .index = L_SU,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SUNIT,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -768,17 +636,9 @@ struct opt_params {
 			{ .index = L_DEV,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_AGNUM,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_L,
 					  .subopt = L_INTERNAL,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -786,10 +646,6 @@ struct opt_params {
 			{ .index = L_SECTLOG,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SECTSIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
@@ -799,10 +655,6 @@ struct opt_params {
 			{ .index = L_SECTSIZE,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_SECTLOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -814,10 +666,6 @@ struct opt_params {
 			{ .index = L_FILE,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_INTERNAL,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = 0,
@@ -827,17 +675,9 @@ struct opt_params {
 			{ .index = L_NAME,
 			  .conflicts = { {.opt = OPT_L,
 					  .subopt = L_AGNUM,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_L,
 					  .subopt = L_INTERNAL,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .defaultval = SUBOPT_NEEDS_VAL,
@@ -872,10 +712,6 @@ struct opt_params {
 			{ .index = N_LOG,
 			  .conflicts = { {.opt = OPT_N,
 					  .subopt = N_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_REC_DIRSIZE,
@@ -885,10 +721,6 @@ struct opt_params {
 			{ .index = N_SIZE,
 			  .conflicts = { {.opt = OPT_N,
 					  .subopt = N_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -998,17 +830,9 @@ struct opt_params {
 			{ .index = S_LOG,
 			  .conflicts = { {.opt = OPT_S,
 					  .subopt = S_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_S,
 					  .subopt = S_SECTSIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
@@ -1018,17 +842,9 @@ struct opt_params {
 			{ .index = S_SECTLOG,
 			  .conflicts = { {.opt = OPT_S,
 					  .subopt = S_SIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_S,
 					  .subopt = S_SECTSIZE,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .minval = XFS_MIN_SECTORSIZE_LOG,
@@ -1038,17 +854,9 @@ struct opt_params {
 			{ .index = S_SIZE,
 			  .conflicts = { {.opt = OPT_S,
 					  .subopt = S_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_S,
 					  .subopt = S_SECTLOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
@@ -1060,17 +868,9 @@ struct opt_params {
 			{ .index = S_SECTSIZE,
 			  .conflicts = { {.opt = OPT_S,
 					  .subopt = S_LOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {.opt = OPT_S,
 					  .subopt = S_SECTLOG,
-					  .test_values = false,
-					  .test_default_value = false,
-					  .invalid_value = 0,
-					  .at_value = 0
 					 },
 					 {LAST_CONFLICT} },
 			  .convert = true,
-- 
2.8.1

