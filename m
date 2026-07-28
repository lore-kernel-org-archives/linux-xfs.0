Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022072.outbound.protection.outlook.com [52.101.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EDB3B893C;
	Tue, 28 Jul 2026 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785219904; cv=fail; b=PNqZi2n0NAF2XhF+Dn2tF90dTZLBLYBDuF0GzKg2ImRBbk4vL/Tkda/xcgtRBMmE9Rr4pkRh9AwnCNLjc1Mdmh1+8ZcOKNwnSDD6iDuPA+vJyg0QL5J/YPrf4msoMZaXwEIAYvwNdk8dg3IvLVueKRICWtxePGRvsVi6g361mvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785219904; c=relaxed/simple;
	bh=Z7vi32SeUM/Fh2UQihm5qBVwkiknohF42PX3TRFwwNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ePeNwc8SgVkCztoYJ4DKy6fJsNxIYyUQa28xJUdJqGAbYcfRO5WKGNQ68Jny9CoGtSQ98AFqBJO9OEoAzKLMIo5LBjCwHL9v3sc6J9ufIfRDORFlWJIBTc+4y33tbXT8PuL+kas6KSu20IqKVGWUi5T3dkfftDwmYkukfR8nCPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nova.gal; spf=pass smtp.mailfrom=nova.gal; arc=fail smtp.client-ip=52.101.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nova.gal
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nova.gal
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1+ka22o8NRMFqKJ6Uj+3mczvymfaOTGQ6X02L9zvBbfzMxVln6mwPb/tPZqwlAl+tK3AW547AXY7CS8jwT/u7zspfnICn9AS5FsN4hu7spOP5SdGmYKHfj/ECc2uEQ99JMsEiP0hLICsr6cpI2LxWFAGI2u7KExv8flu/vYl5vr1KLQ9fg2oyet4LOKTLMaoKaZLsd7D8LO4VCdt8RFwgIalqwNb/SFVq0VRAWHqF5J7XuEHGTiG2v75uIG6sKJ4NxksoYBHZc+m0kJLxpKxAvVAle8UOMtB1SkTVG5XNQXPKgYVoXu2zsGb7K4U8jrERGcLMWabwK4eL7E/royKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vDxRhEbpgA2xMzUYAstbrkLsPVHBg4mPegEk6SEEJ8=;
 b=lCF9w8AGfFG/f03HFUStyO636w8g5kQ3dSu4e1sumHVu00UvtKK4oOF692JvPKaRjKR31tBu46ngFD49ztW6XS+KURRf2Jk0vLz/y4oryhebrbkqQCydcoVsbTtjvKvV217Q1DfKU6Fyk9N5JpYtDNN+cDn8eVEe/HZv/tjSCQgHny7Oae5kiSNwN/Cip6DcpmS3bvjI+BmjcfXk2PvB9cC/cYM3gUVw71HCHhHcjFqiS0vUs6V0hoiP3FHvNHcmuL9/TFDkruqcES6Ua7fU96oa1Wo9H0h7cuQ84hmWGo+WcIY82luH5dYencn2vig5wP92JqMiGg8cBLRMddcsGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nova.gal; dmarc=pass action=none header.from=nova.gal;
 dkim=pass header.d=nova.gal; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nova.gal;
Received: from SE3PR03MB9967.apcprd03.prod.outlook.com (2603:1096:101:336::7)
 by KUYPR03MB10554.apcprd03.prod.outlook.com (2603:1096:d10:78::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 06:24:59 +0000
Received: from SE3PR03MB9967.apcprd03.prod.outlook.com
 ([fe80::98a1:50ec:e93e:e0ee]) by SE3PR03MB9967.apcprd03.prod.outlook.com
 ([fe80::98a1:50ec:e93e:e0ee%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 06:24:59 +0000
From: Miao Zhao <muel@nova.gal>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	cem@kernel.org,
	bfoster@redhat.com,
	linux-kernel@vger.kernel.org,
	Miao Zhao <muel@nova.gal>,
	stable@vger.kernel.org
Subject: [PATCH xfs] xfs: validate remote attr value length in the leaf verifier
Date: Tue, 28 Jul 2026 06:24:51 +0000
Message-ID: <20260728062451.1296908-1-muel@nova.gal>
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4P286CA0133.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:37f::16) To SE3PR03MB9967.apcprd03.prod.outlook.com
 (2603:1096:101:336::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR03MB9967:EE_|KUYPR03MB10554:EE_
X-MS-Office365-Filtering-Correlation-Id: 66a3c7f9-c739-45a9-65b5-08deec70f359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|34036016|41320700013|23010399003|366016|1800799024|6133799003|18002099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	iEjwQSCGOBAojX6o1sL395w4uPklcS5kOKY9OEmdewZJZJPz9BF4GStfI2O+MQW1Z1KLXnz7R0s++diKboE2aoMrVtb1FDfMPidoRMmvdgvulgG/ZhSVMOcB0KHVBaA6ZucCvq91koBCI2X73oxCzK5exormXzaUs++OJT2ASpfGaqTNJohnR6mUVp9IQKbzZLOGjTta3ZF1kEVaAx/+tdgf9bAKr4VaYSiH6GvtU4f36qR3XYGGWoC+Zq20CAJZ03Yi+w95QRbC+Ii21oTnHBaUSkDdYHrtoNb/Auz9rxI4wZhN/YKZYpZVyU2YrWI+3WVB9Z0fZkMD9TOO+mrJhdxaqlcmiHuhfS3mxQwlyjo/PeMi6t+1z6gp1Ifcbp4Y4EyYFCIAydQDM9fGlV4R8K62Fn8lgEZxC6HtmgjLBROHaam+epIlGK6NM/BcX7mtchdMJk0MQHePtcNXTS/MjmSNCyjtkTexot2d6kswFLF+66idrgayTke7wGh8Zhp7ppBNGaOxa8fUzvc6/asgZaNAfMiV8tlGqIF/vHoK77lotiipp3h2MG0RPgjkU8yBUMS5u975BRGJbRQS5Zgo8AqyH+cAuTMIKBpKgRwanex0g2YzgoB8qs4+d2M4VjXQrD0Uybh8dEFyh1GjdYrSFumKSRFKpg7TIk56ZQBVX30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR03MB9967.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(34036016)(41320700013)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c2UbxRTzgBVdNMWfmF0D6F7ibF8BGh++/GdbS1zhutmKmXQUjADhEINEtzM+?=
 =?us-ascii?Q?/zElgpsf9FGeVuLEoMvzeMPJublJS76bKNf5HK1oKsJJUeQzwaYZnNBOXB+Z?=
 =?us-ascii?Q?16Uh4m3SQpzeuQ0EWMyziLRXVfCp2t7vVRLwD5KcgfSP+PGBMDYtBnGni+E3?=
 =?us-ascii?Q?J3oF0WitI4+acFs3aqtXGPFENM+RmkRez+HrPyBWBLvh+oAuDLIysaV9h64W?=
 =?us-ascii?Q?odnxt2ctaTWDPDaOw0Nq4dALyyawS8ui2oR2bHjdn7Ut3+XeMCAxBTbkGqMa?=
 =?us-ascii?Q?XT2ormCrjaWTf2+vRJDhcRmU8mJWhPsBbKxvF4JKOlB+Tw4ES00LDKcsV8uh?=
 =?us-ascii?Q?NPOGolAYtxKszKc4/Mi1QezPU5mgR0k6XtJXDevtszN1WzYEepZ7J4MuPJfk?=
 =?us-ascii?Q?BBrDT8l6xFw7q7q/1dHonhldwMqzNiXAba/Wiq1qXPI32KGf/2DO2g2begSN?=
 =?us-ascii?Q?dbI1Q5gNdPuIuAJhdCY62fpauSMCjjoTeRGPmfYbK2PFvH9KrfBh3c+vTauH?=
 =?us-ascii?Q?18h4AlUG/eattHmP4wCZpG53eapL0U0zfErdES4IZCwXUJlUh6C8Aj4g4KmI?=
 =?us-ascii?Q?J5oHJ3BimoBP8mgTzBBHDUTMAlTD9ncYXwWybCmKwDRk48F7xf555Rtvh/Kz?=
 =?us-ascii?Q?4/mD0MbE/SOyqO4FTpz/KNu9SFXH+tCx7ou6Uel6XC/FWuKgmdBtu+NBsB4J?=
 =?us-ascii?Q?+zmmreL6bU1XAN0Sqfx3fSm7bTdzm/z9bqIqkWQJ5FXGpnMVbfsC1h5Za9IM?=
 =?us-ascii?Q?4aVMr3O7sIq1F+URfSOYkVM0xr/2OxEq5ffdGzrdzSeP8pQxCTNIzSd0R/Td?=
 =?us-ascii?Q?qDjO6jTKLNjqJEJIKsLiLgzDJm1zmqZ8WgydW/nEqITNmbqvvNInXUtl6MnD?=
 =?us-ascii?Q?J98GMlptmz7qEa93c0ewX9H+ifyAT2v8TiwTQCKpROmZdjZMvJ2/UleK/NI0?=
 =?us-ascii?Q?YRyTmyy5+3kVBEcksMFj/fm9IMtmEGNNxkpqS6yAUlZqsCS78pWJxX0TGG05?=
 =?us-ascii?Q?VLPa2HGycDwSLJd9poXFDxe35Qc5rsSgXpDGFCAXqV0EOiA3A325m5WoI+qS?=
 =?us-ascii?Q?2FVK6BHBhX4/QID1O9FkwjhTNkKlBhT4lopF90VwDKaWo/j3F8LKM+zdkva4?=
 =?us-ascii?Q?eQkQkuzROGy0CkYr3J/U+gBUMWzYlQiOocis1fwpZYIoVhd1n85X12NRcvOy?=
 =?us-ascii?Q?ujvcHpKU6twQgeo6URjwICb0REEHotRXU4MTw6EgrQfJqexJifJGr0eP4EMp?=
 =?us-ascii?Q?Bb0LRJ/2NXOzuu/h753CCgxig8eKZmBMp+VKp8hOmrv7g/VtGf8QGs81wOjK?=
 =?us-ascii?Q?S9QXNeBvzpXV3ogS2RgMJlx86lm6pZONV8VbX4Fz/3oGr1Fh8s0HlQdfrkBh?=
 =?us-ascii?Q?J+ICJzsDtnGm3nkNxb0spFOQ8S8/KVTtCgHOV52aCi4YKIRLSYX53LW8s3Uy?=
 =?us-ascii?Q?co4iiHNtCCNTjH5H5HK05fdTae0yIydkZ6OK0xcuYtdGFqZRPIqHO6ID5SND?=
 =?us-ascii?Q?6X7pOP1WToqRK02ILA3vxnLDEDar1RPP0x66vnhd/RScNy1+DNeICkeFZ/4j?=
 =?us-ascii?Q?RCp16+YUpyuoyA9fAfbM0bJjoUz7CWNKs2wQVPA0Sm59QF70vmokIZuxDBRf?=
 =?us-ascii?Q?dezjg8/KBtQF31Dxbnblwmel3IXa583NMjGs8FR90n7UrDxBoi2F71chJfOQ?=
 =?us-ascii?Q?sIrmrDHaIzY2bCfYwvouIyCnHobfFjY0oWgWswk7/U0PLrl/?=
X-OriginatorOrg: nova.gal
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a3c7f9-c739-45a9-65b5-08deec70f359
X-MS-Exchange-CrossTenant-AuthSource: SE3PR03MB9967.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 06:24:59.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2adae87f-1bb3-4442-a538-a57c857641f5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YU70OE2uFmO30HjJcAGWFGBjwTcIZODRd7JKQYdrBbgXM5Tk5gDCteoCG1WOK71U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR03MB10554

xfs_attr3_leaf_verify_entry() checks a remote attr entry's namelen and
valueblk but never its valuelen. A crafted image can set valuelen to a
value with the high bit set; xfs_attr3_leaf_getvalue() then stores it
in the signed int args->rmtvaluelen, where it goes negative. The
negative length bypasses the -ERANGE size check in xfs_attr_copy_value()
because the comparison is signed, and xfs_attr_rmtval_get() then
reinterprets it as a huge unsigned value, driving the memcpy loop in
xfs_attr_rmtval_copyout() past the end of the getxattr(2) result buffer
with image-controlled data (up to ~64KB on v5, where the remote block
header verifier caps rm_offset + rm_bytes at XFS_XATTR_SIZE_MAX;
unbounded on v4, where remote blocks carry no header at all).

Any unprivileged user with read access to the file can trigger this
with getxattr(2) once a crafted image is mounted, e.g. by a privileged
auto-mount daemon:

 BUG: KASAN: slab-out-of-bounds in xfs_attr_rmtval_copyout
 Write of size 4040 at addr 0000000061bf4ee0 by task xattr_tool/37
 CPU: 0 UID: 65534 PID: 37 Comm: xattr_tool Not tainted 7.2.0-rc5 #1
 Call Trace:
  memcpy
  xfs_attr_rmtval_copyout
  xfs_attr_rmtval_get
  xfs_attr_copy_value
  xfs_attr3_leaf_getvalue
  xfs_attr_node_get
  xfs_attr_get
  xfs_xattr_get
  vfs_getxattr
  sys_getxattr

The same unchecked valuelen is consumed on the INCOMPLETE sweep path
(xfs_attr_inactive.c) to size stale remote blocks, so validate it for
all remote entries: reject valuelen larger than XFS_XATTR_SIZE_MAX,
and reject a zero valuelen on complete entries (a value is only stored
remotely when it is too large for the local format, so zero is never
valid there; INCOMPLETE entries legitimately carry a zeroed valuelen
until the operation completes).

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: stable@vger.kernel.org
Signed-off-by: Miao Zhao <muel@nova.gal>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 86c5c09a5db4..b8ae25be639a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -336,8 +336,11 @@ xfs_attr3_leaf_verify_entry(
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
-		    rentry->valueblk == 0)
+		    (rentry->valueblk == 0 ||
+		     be32_to_cpu(rentry->valuelen) == 0))
 			return __this_address;
 	}
 
-- 
2.34.1

