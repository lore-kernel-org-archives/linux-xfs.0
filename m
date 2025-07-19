Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011039.outbound.protection.outlook.com [52.103.39.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3A92D613;
	Sat, 19 Jul 2025 05:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752902539; cv=fail; b=CRPUXR6HgxZ5y/0rS9GIYgVhSUCelFVRe9G7RyhP4jNGUabNf/JbNQraLmGlg8MfCIqqR3h/okc8purAlgZZIX9ltNig/cDVT0rTa3r1Kg+tnUX0aMWvBlLYLIjalcJxcGzXfuuBgMKIDP0+aK5Wxk2oQmC9GL8vJ7/NfXLSNuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752902539; c=relaxed/simple;
	bh=26Bv5qq2FfDaAFrlU/QF7gIk3ZxXYNaOdvGKzwMBwLw=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=FdhclVSKxejQaOi7kAxLq6CJVakey93PgH7IUPhJg9lkAkhq4ayqbsJn+OXatWJCATAU1c/iFovwhZ9y/I4D0SLFibVA7FCuntKrbYs6wSoL+0e4TiOPZob/+Fppix6lxalQFixwyRQ27gtRVGChtYo1NpCHuLTb8+gEx0JchTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=hP0OExVF; arc=fail smtp.client-ip=52.103.39.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="hP0OExVF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPDeAg0/2vKY7zITg8C7jUTBUA38rMM92gM3RgW0E2yG4cRMhUSR3Yqgy9ciSrwlcc2r6QUf/SzWcOt2f0BdaDQGroVwL4x8eVCK76zKzivEkUKqtQZswiiWQJMZlqyWg3idn/IMZzrKMD+IMINfu68GoFFaq7GofGmFuw9M5HM4s5L1xnIrPprTavNTFzmhmF2tfZXIHLqpkSuqKNI7bCzsr6wYh+fQ9ALxYM/9ip3klLJ46Ovo+4/t3iKdr5eN45fxnqDVLvIKKbvK2z56TJc3ffkMToXzLrjE/FdUEgylG42PRnGuxvylwV3dGKpxliubpUpV7rLJimkafnJcbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suCHxjHzPzVkUVKSe2Vfclpo7TG86uetVvTJ+XruE34=;
 b=yBjjjOSgtcljEkcetQkv302QfH5oUK2UaxiIO6s7GSrgLjs58mO+0nkN7GSwxGbL7WlrCowHeQq1NAAbb5MMpn8vIwXRLKjI0ufQj0U8XCNayKgg9hviz+0O87X02/3EKBtoAVptXocOEdOLxAsKvz3QKIiWOx0n8B7n/TUA6j/Qd/HTHpDaZgb7kqWEV0Hdp5WmmPC6CCvdGlCxnYbeRvpaiBbwVP3wu56dG+WJ6sQuLSkiS9LlYBDemE+T8ZD5uSel1z6zKGJseZzsHe6QLxWxmwBFFdA0HBITSN3w1bUDhUVUiThecovuRKIOd5xUBzFcr8rUYaVxyfCKkMpX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suCHxjHzPzVkUVKSe2Vfclpo7TG86uetVvTJ+XruE34=;
 b=hP0OExVFKzkgTIr/rA5w5oLXEsSJVnrugz7cAqG5/5hy2EHD3cP4y0Vm9ylWn4/5VZEBUaV1Ul0xcv2L7jptGNKV0A6ZUvdknz0spkspoTwID3+xPJHmJD2VHJLyS3bPkU4KXTQocLsrvWKKrlYrOxP6y9B2hUhsImyszAeMbv/gYhvjuDnWBBB/4Pc2Kto8hwXe1H6q03dCQA4wg7vt9CwZC/5beDKOunHJUdKikzq+CyMyhsnEQ9Lbu5vzcVhwbUrsQggRt1eiZ9BSUliaTXuryMyD1sGjaFr5rXtWPsAhF2fg/v7EDHwiXZ3/6BvfQ6H6ZaQ+bOIxHgF1oTqx4w==
Received: from DB6PR07MB3142.eurprd07.prod.outlook.com (2603:10a6:6:20::13) by
 DBAPR07MB6552.eurprd07.prod.outlook.com (2603:10a6:10:18d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.29; Sat, 19 Jul 2025 05:22:13 +0000
Received: from DB6PR07MB3142.eurprd07.prod.outlook.com
 ([fe80::48b6:9e2b:c22d:1607]) by DB6PR07MB3142.eurprd07.prod.outlook.com
 ([fe80::48b6:9e2b:c22d:1607%4]) with mapi id 15.20.8922.037; Sat, 19 Jul 2025
 05:22:13 +0000
Message-ID:
 <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Date: Sat, 19 Jul 2025 10:22:09 +0500
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: or10n-cli <muhammad.ahmed.27@hotmail.com>
Subject: [PATCH] xfs: scrub: remove unnecessary braces and fix
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0021.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:20::8) To DB6PR07MB3142.eurprd07.prod.outlook.com
 (2603:10a6:6:20::13)
X-Microsoft-Original-Message-ID:
 <f21b238f-1074-447e-b1e0-96cc3450e328@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB6PR07MB3142:EE_|DBAPR07MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bdba1e7-6994-4334-636f-08ddc68437d4
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|5062599005|5072599009|41001999006|37102599003|461199028|15080799012|440099028|40105399003|3412199025|26104999006;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejdzeVhHSXhqY0xNVXM5eFhacVNZcCs2S3BFNUpBTk9oaUNsRWptajJRR2Vp?=
 =?utf-8?B?ZmVIZ0tMb0R0ZHRyS2JVdEJHaTk4YzEzbnlWbmUyaHdMZDg0aVdCUk1RUUEz?=
 =?utf-8?B?RWNsRk1TR29TbjVORktCcFhreXd5VHA0bVdhbTRJN0NkOURBQUJSNTFMOThq?=
 =?utf-8?B?Yis5NVRiRmdlTnlOMVk0MkxlK0dpUWk3Z3hxYUc1WUsrNW8wcXBSTWtmRm11?=
 =?utf-8?B?VUtCbUVWbHhzSTMzdkV4QnFBNVM0c3VOeE1lQjVNSFFQZ0diUXROdXlEVXV2?=
 =?utf-8?B?OHBDSy9JR1BIK3l1U1llVjNZeS9XRHRjOUovYmcwTkxWUXNnOFU2TUNPbkhj?=
 =?utf-8?B?OHFOUDJDbXNYSGRkUStqZDVlMW9BdG9FaWNkKzcwd2thWU5FQ3UrTGwzb2dM?=
 =?utf-8?B?SHVJUHVOaG9kSUlRVzFkbWhxQk5oTS9mV2grbklrNUxtNkhmK3JNSE5GN3Fu?=
 =?utf-8?B?eEwrMmJ6QVRVK0VRRWluenprejUzYlYvSUpJRis5RGpaNHNNSjdKcWNTdm1n?=
 =?utf-8?B?Q3V0YUxXZ2sraTNZdStEbjI0bGhldHVIbldxbUkyRWx0WE0rK05IbHZSR2Jn?=
 =?utf-8?B?OThvbVRveHRsd1BoZUkxN2JDOFQvMTlZZDJidEtXUVlURDBmNTlIMWdMNjJi?=
 =?utf-8?B?bGJMOTV4cFcxQUpUYndCcTZ1cmZPUG94ZHNodmRaOVo1YWNWVCtjVWVWZTdI?=
 =?utf-8?B?N01oTmpLaEIxeVE3dlU4N1l6RjFTcHlaSlNKZGFuRy9wbXhYSE9pVVFJd2Jo?=
 =?utf-8?B?VDRrQ0c0aURsTkdUOG1xbm54S0wrM0ZVaGc1UWVKSVBONHVjejVId1VYS3No?=
 =?utf-8?B?eU1scEFuNlhGWHM2eGhZZmUzTFlEY2VKTkhvZmhNVm1TWjZlTXZTeHpYR3hU?=
 =?utf-8?B?RW94aUNXcUNvZm8vZFdsY255RFl4Ym9UbllnRHoyR3hjSXVsRVhtZzNaUWNz?=
 =?utf-8?B?VDhONEJ4QnNSdkZnSnJzREw1R2F1RDIyYlhvRlFpa3FxU2s0Qm1JSFlJUGhx?=
 =?utf-8?B?b1I3VHhOQ3VnZUdDUGt3MDUxc0UyZGhwS1FzU2dPaTVkU29pTHE5VS9CUjVD?=
 =?utf-8?B?WUV3dlpwbWxUMkIvelU5d1A5S1kwWE1qZTRBbDZ4L1JIcWdIcC94YlJTRVFj?=
 =?utf-8?B?UkZYQlBjYk0rTXI5STN1ZUxWS09LNmZGSmgwQy9YbVFKT2VFeDduTyttNFky?=
 =?utf-8?B?WmlOKzA5QlBMT25LYVJuOEU3VzhFN0pweW1NbVRKaGF2cndpeE5DSjRxcjlC?=
 =?utf-8?B?Y2FEc3JiL2lUeHdWeThDeEl5azdtbHQwZjVFN3VWQlNyRG5DV0k1VEU2d25R?=
 =?utf-8?B?UXJHbHN6ZXE5WDQ2aXdNZFN6YmROVzJSZjZRdHpFeWZLMS9ud1pqUzFFNUdF?=
 =?utf-8?B?VjZsOXJhbzlwWllhNnU1Ni80YVhlQ2lkWlY1eEtnRW05dEQ0cDY1VWhKZ1V3?=
 =?utf-8?B?UVVpVUROVWRVVHg1eWoyQ0JhWHNtdktLK3JVNG5uYms3Vm5SMm1VbkJEVHpF?=
 =?utf-8?B?TnlMSkNoTzI4Rk5UbWx3UlVlMm02YUF3clk0eSs1SlorYzNWSDkyQUpoNWhS?=
 =?utf-8?B?SmlBbHJLb3pQSk5nU0pKVGVSR2pMVWNuejFjQmlUODNZK1pCUW9XUlBDVSta?=
 =?utf-8?B?Y2JyZ2l4UTlKd01BZlpqR0xQRnFkcmc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGFqVlFLdlJHTjlMajhpbS8yOWZVUnJGWXFXNlNFQVhUTC9XQlJZaFIvYnZP?=
 =?utf-8?B?YXpMTWNGVmFvMjZ4TThFV1pzTnA5MHpuQnFkQVpDVndDeW8rR1l4Zkh2Z3hE?=
 =?utf-8?B?VXNaRHo1VktjS0lieEY0bmRYd2FQbWJvQ3JhODVlYTZXRmRieEZBNWFzQzRa?=
 =?utf-8?B?T0FmUGpkajRGbW5Rcml4Wlc2NnBIcEs5V1VzVCs5NHM3UWtVL1dNYUJWdDFC?=
 =?utf-8?B?ZWQ3TzZEcTJmT3VncEcvek1IOHRSYUdZSE9rWXVkR0x0RldSN2gvajF4cW96?=
 =?utf-8?B?c0t4TGh1c1NQOG84R0JKUmRSWkFzMHdnSy9nN1R0YnpLejRTWVA4YlVvVkt0?=
 =?utf-8?B?ZVVlQmZ4akJ4THA5TmlIQThSZzUwTUJuUUkyc1RRV0E0cG4vUWc5R3VMTUU2?=
 =?utf-8?B?WTRDUUU0SUN1WDlwNVAwL1Vhdy9ScWxLN09mMk5yTEFCYTlWNFJNRUZmQTBH?=
 =?utf-8?B?ZGMyVVhaNktFOTBFWWI1aS9kd1ByWG0xWmhrV1VrSHJJZGFOVnZEeVE3NDI3?=
 =?utf-8?B?Mlk3NHcyOFcxUWJ6djJsSU1BS2lCMkhjVndZVTZsS0NicHJiSUhIcTEzMmZt?=
 =?utf-8?B?eFAvcUJUbGVJa3FKZ1g0NElTTW1NNk9QUnRhVVR1RUFHM09wQVhPelc0NTJt?=
 =?utf-8?B?dmtwWC84Y2Nzd3pUbVJER0toQlhnaE9qQlFwTDZReE9MLzM3dHo2d3c2S0xm?=
 =?utf-8?B?WUtZNnNhTGRINjNqWHN3UVVxSUlYaG1jZ0tlNjhyQ1ZRNnMvOHNydE1wNzVL?=
 =?utf-8?B?dmUwbEoycUlEWHA1OXNmT0JocVpCOFduTlBuQ2dBWkZMK2F4ZlA2eURkdHZu?=
 =?utf-8?B?cCt2WU1aV2JQMmp2RFBldktIaytMcW1jY0NyUFl6b0kvWW10RkJlbEpaeGJD?=
 =?utf-8?B?TEx4WVF5dGlBY3E4YWVIODJySTVnRmlpbVo5UXRpNkFXSTBNZzdTb0VKcE80?=
 =?utf-8?B?Mkt3ZnlpK3krT3kxVzNkVTVWcFowTmdMY0JvMGNNS3hudy9JSFU4dUFBWmNu?=
 =?utf-8?B?L3A0Mk9iYTFsdXh6Mk5La3pzTG5yYWV5ekF4WGVyRnRJTnhxTHByNkFlREZy?=
 =?utf-8?B?b3JYS2x4MHhBWVR0Q2ltcWJkV3pFemZORktPcFZhQ3JxdWlTSCtNUy9TQWJT?=
 =?utf-8?B?ejRQUENwVW9sbEJKQ0MwMHU4eEk1UmFhdG42bkhnNGFOQm4vaUNDTU15SXhF?=
 =?utf-8?B?aUdDeUNNVHlIRktUNTFTQUJqOWNpWVhtN2JuN1lLWFlUNWlPUGxlVUlsQXhm?=
 =?utf-8?B?VlFDRURqczBSVjJtSW9OVCtCdFBiamt5Mk5YUlY2ZFlpODdUcnJSY0J0dHNL?=
 =?utf-8?B?NzU2bDZOd2U1K3pqZlZYZXdHNHl3K1BOVloxUlYrNlFLVGYvU3Y3alJWU2cw?=
 =?utf-8?B?dFBJUldLWTJEeDVZZ2l4NUdmV1ZwTVZkVVJEcW5tUEVTcnI5V2o5QmZ3bXM3?=
 =?utf-8?B?UXlwL2w5cmxiVndvZFc4aCthYXM2R2pDL1ZXSlRJRmVPOVR3MnFGSU9aQm16?=
 =?utf-8?B?cXRPVGFta1VPWjJpcFFnbzRxSHZTaldMRFI5N1A1WFpBcFRpeHo0YTFsYlFG?=
 =?utf-8?B?TWNQcmVFWW83Q1NVWU9FdWhjZmR5OEZaMHVDaGxsRDZmZnZKZExPcTFzQWNC?=
 =?utf-8?B?bUxNS3ZnS0twNmVFUlJuWS9LNGhZNEpBa0hnUHF6cXRRUHdjNXcvRktiVUlp?=
 =?utf-8?B?dis3QUZ4TFl4NVhlTkE3cG0rNHluR3dBSW1JNjFFMUxtVWFiWGtoeW1RPT0=?=
X-OriginatorOrg: sct-15-20-8534-9-msonline-outlook-caca8.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bdba1e7-6994-4334-636f-08ddc68437d4
X-MS-Exchange-CrossTenant-AuthSource: DB6PR07MB3142.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2025 05:22:13.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6552

 From b8e455b79c84b4e1501ea554327672b6d391d35d Mon Sep 17 00:00:00 2001
From: or10n-cli <muhammad.ahmed.27@hotmail.com>
Date: Sat, 19 Jul 2025 10:10:42 +0500
Subject: [PATCH] xfs: scrub: remove unnecessary braces and fix 
indentation in
  findparent.c

This patch removes unnecessary braces around simple if-else blocks and
fixes inconsistent indentation in fs/xfs/scrub/findparent.c to comply
with kernel coding style guidelines.

All changes are verified using checkpatch.pl with no warnings or errors.

Signed-off-by: Muhammad Ahmed <muhammad.ahmed.27@hotmail.com>
---
  fs/xfs/scrub/findparent.c | 9 +++------
  1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 84487072b6dd..9a2f25c7c2e3 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -229,15 +229,12 @@ xrep_findparent_live_update(
          */
         if (p->ip->i_ino == sc->ip->i_ino &&
             xchk_iscan_want_live_update(&pscan->iscan, p->dp->i_ino)) {
-               if (p->delta > 0) {
+               if (p->delta > 0)
                         xrep_findparent_scan_found(pscan, p->dp->i_ino);
-               } else {
+               else
                         xrep_findparent_scan_found(pscan, NULLFSINO);
-               }
         }
-
         return NOTIFY_DONE;
-}

  /*
   * Set up a scan to find the parent of a directory.  The provided 
dirent hook
@@ -386,7 +383,7 @@ xrep_findparent_confirm(

         /* Reject garbage parent inode numbers and self-referential 
parents. */
         if (*parent_ino == NULLFSINO)
-              return 0;
+               return 0;
         if (!xfs_verify_dir_ino(sc->mp, *parent_ino) ||
             *parent_ino == sc->ip->i_ino) {
                 *parent_ino = NULLFSINO;
--
2.47.2
