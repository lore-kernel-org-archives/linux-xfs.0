Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9B0288C10;
	Fri, 11 Jul 2025 10:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231237; cv=fail; b=pjATegD7rHNlqtqtxb03ClzEljo1m6DdGo8sNke5jX/MBXczEUMLdM94ZmRQr3h0cEmITF+Vt32xPINNeTRRW2ECt18gjTzyachR/l1Vr/DTA39dq6YfyaF4CFSGRf4YKNQBAPmlkEDxd9faa2by3qnhA8mbfIAGhQZSKoNnsKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231237; c=relaxed/simple;
	bh=DQhnhzjfH+aoz9q8IAnlp3SHyOUe926/6piV/+jU2JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mr5uKd94oB5SjXRI5GgfFX1SiwDT4NbyJZNqIYRvTsUc3UeatFElPcgLa7zf/87mvg9ekugjV2GMYUCcVkZLq2SVQLTr/j3Jm3gBIX5Cue1k4IRWbALTo5OrRh0geYVl8/EXCZBWsewb5ZgOqXza+XNy2b2qNGl82UvfmgtI34o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BpEnOVfL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vyZdjYMj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpEnOVfL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vyZdjYMj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56B9Z0tU004850;
	Fri, 11 Jul 2025 10:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=; b=
	BpEnOVfL4zLqcxbhC/THY1jfHrZX+pCOm811O7yKJZZopRoPfkp7mlvaBYA7Sgst
	nmhaj1JiTvIhySkpB8/0xR7/hqbU8XFVs4vFP/UnZkPJ9adHkgSOYi9Ct4bWqCqO
	wZUKRshaQbf+F8yiqQyElVrC9pk6oYMsL4RhvVtOhfCwLmL7xkfUsQV7ldFJKNZd
	lnNngYhq4MVlVyxBC3fBYf16Jh5hKamjfqemF5RVZ+RtghqR1j2ye4Mk+G0I3WWD
	86m7fiVszIxy9RMQ99aWo4CBxBPOJ53CeVpC+PxbkLIwISUptkf5iePM6Strb1tJ
	kyLAZPu4g4M39Y9f7LiOZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47twjmrd9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6d021358;
	Fri, 11 Jul 2025 10:53:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vs/EzIXSnEdC42jjJ/dPgjzZIF6onsMozwso7LXO3E5j1uGYnpfxZD3m4heKqi6So5hsQBNaWYmQ8Ayma5rpZsuV43SV1q4l2olNBRKbBHQ6FSGIavZbA/Uhp/Kfso/MhpUkzW77IP1cLelXm79KhS9PYeJSDiMzUFwdcMi53qKdbPb9fyyoWI9oC6nsyzQz5W8DvZeao1t8sFSdkuxlY7Wmj9/y0lmzMq2jg1Xv7htmpuUz78ptyjJOjmGM1waci5xWeE1m30JYQewc4s8nOVbOsZ9M+JxktiAtwVZoGv2Ic76IjKrGvrECmF1JNgbuan+w3TQKj91CLNh+ij9mRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=;
 b=hFhpqDip4tvHziHUlznKaAE0NxGPPoiSdk1JJUN+SbklGRt4L3qxJZ+d+V+KXBk6qbdz5xN1anO2XLTqjiNfwF/Xv3FqTxfHfiGv5pa6EOuesL0fBwuxjrArRINPtmZwsPAsvuAyasht/Lmpln6WnfC22elQV4xNFPwJqXqRU33JtSJviDVIMfWl7YiT49oDhDCtG+W0wW3vYXvvk27mS8gXeyp55PLNvVuEaUHc+5HEtJ/3Pa/64TR7n2qkwqftFG8QifRyCDbIeJmvR5hR9yH5bEIZX/GdERPY8s9EPcl7zmaRZNFyB26Yx3JtF+VpVbACCQZk6N3kHzRPXlWQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiWSjqNq0gOEAPA7275dnsi1ypPx00lLfAhOczaIDHA=;
 b=vyZdjYMjgIkXJCPYJFHWz4iZ1nXf6TJHJ+xEeM6GqpiNgPWoorr/HSwz2t6GOCZK3sTDwGKCRYt4yGeDOVKdvVLh+rKw1vbxzIymbMaP2HZMWRIIuwWvJZ08S9rpw9RFv3mijfpq5aO9/uBY9eBrDGdK+bhOoDOuy3vQfBCVVog=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:13 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 4/6] md/raid10: set chunk_sectors limit
Date: Fri, 11 Jul 2025 10:52:56 +0000
Message-ID: <20250711105258.3135198-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250711105258.3135198-1-john.g.garry@oracle.com>
References: <20250711105258.3135198-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f01ee09-cc51-48a1-4d11-08ddc069221b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?bWB4IRtvFx17cN6+jBzYuuwMUfsB8Y70XBAPEOhzBZg401ZewYvMMToIRl8g?=
 =?us-ascii?Q?joiwYUwHaNtnA2dwiSitioNCXXasz7wCbAgIjec/O4yEhWUMu12cCS+5Wuw0?=
 =?us-ascii?Q?/gj8/yV60dJWLbLLEWu54Lr2yo94SX7Q/ZTOM1GTIgW5WwbxDuijclycdJVL?=
 =?us-ascii?Q?T7m/xUANmk6RtF0nNGXzoRHvdFJS5I4lO//xirRY0uQMA2RwNDdxrwB6BsRB?=
 =?us-ascii?Q?yJOBc3wTz5F3n3hjZjeKrNmV0Jtkjbp+EOT7WrJQG/ccaCBxBQ1ShatantXj?=
 =?us-ascii?Q?anGjfGwKxWdDQZFk1dn4oLSyDniYsMqM22Qgj4PeQKPySc5eVWCUM1+Nyed9?=
 =?us-ascii?Q?C93C2KZeGqmlKEK0lPevkoTqqW1kbfctY4OxfFJm/XgwppH9vIRf1UxX/vzh?=
 =?us-ascii?Q?s8/5wW/6KKS3dptwxnhNGZuSJh43aGMreZF2Swh8DH2taVwDiaKoTIpLbNCr?=
 =?us-ascii?Q?Fhb0bhBGcwtIw66IUfYccrGHBbYvBBNckrjlbIGePWDoINuQRQmSuIgfCQx8?=
 =?us-ascii?Q?ibIQcvcUzi+Q++1GQQc/E/kIbB6ha80slELne2z1ElM6CzPMvU1BGViYZt8v?=
 =?us-ascii?Q?b5nS2srswzcBQUFC2Veh/+jWuhWF9GdD77Ayv5USJBN76upFCCQ+c59zFjOH?=
 =?us-ascii?Q?9rePvz8M86nFU11poiig367sd9mIO4OVOqSSCPDDiqEJhLi/im21hZu/B+j4?=
 =?us-ascii?Q?0MWjJRnWOpVmKK8a5gM4eV+peWmYqYOKaDHZk4EPFgx7CdJ80xcHkDzT05n0?=
 =?us-ascii?Q?rNdrkaqjxmhumqPYDu2GTJ7EawWPchjWNjU0/7AiWyvrB73xKxaIjBl837ml?=
 =?us-ascii?Q?LNfz6XKnqC58tq9XE5ui475X9J6XzlMApRNItoUIclA4PXLv5kZMLgll1e15?=
 =?us-ascii?Q?XHV7QaCaKY9gG3Acu7OckeP6t7EBamVZVZUc2A54XCXA6G+51cRMzHVXieC4?=
 =?us-ascii?Q?gHztUh9rSVqIpKh0/22XIsiyc5/abrEva97JxqTlaF/AZwS0L9fEYUN5ANp8?=
 =?us-ascii?Q?BnAECT1fKflgS5yZjN2X2juIoY6hj3o95CSxUPwfuRpWaeDGoLQaXSELDK+X?=
 =?us-ascii?Q?zWAcKGMJFbwM3Tgpf+OS7vZ2JE6buysvSUpZ2XYSbIagO+/FiwgLJfSS1P4C?=
 =?us-ascii?Q?0wOpggJYfViIqCrPtg59nYnMn84z7hViV+OXMwJLbqeVx9Cv5IDKLu7St1h6?=
 =?us-ascii?Q?UYffR15N40JbyOCft+kw5kZ+6BVKgk3cJ8ItoBlNDv7mcBGzLk010rKh4G9t?=
 =?us-ascii?Q?P78nyfPuaUEtdfnXOs+lX1pCGsfP0oB6FPvJ6prc/U14xSjuFQR4UNJlN8aN?=
 =?us-ascii?Q?nB5d6rgxqXsHkVAeqI6IQ4gHCbOHBGJW0Lte8+T9pcWGQRjxl/N5DuJcfdkv?=
 =?us-ascii?Q?QijtBSVbD4U5aiQrHE9CtskXfhWXDlz535Se2YU3w7L0SXCvnsWB4aCp3MJK?=
 =?us-ascii?Q?SNROMrFzuzQ=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Uj26Yi8q1jRs8qd8YMi5KW86RGWfuJaK2gndAcVsg0TXHz8iWlpKvd5Pizmy?=
 =?us-ascii?Q?XjNaKYtPO093J7xeLCLdPtTCtyTrkAYD83yumxD5VxSN8/qxJ/hIqO5pXY7h?=
 =?us-ascii?Q?D/x8MFe/7UBQDpY7Ct4fEOedI0NFUfdP2dqoWNkR2p2yNwNz14luWB5QxfZL?=
 =?us-ascii?Q?0px5CW9BknMRD2z9SBFtMkzd/+hy+n514Mda9T/kWhtsj05vHFBij7f9Hc2P?=
 =?us-ascii?Q?0SYguNF/Dn+k0Fn9+ha8YWNDvzP+/z39eite9PAhY/SfizaWLcP+9V2ntZM1?=
 =?us-ascii?Q?Kr293mmE5D3mtOXQb5m4wuKxySlHy00kV6qwbZRtCApRn5lg8ppuUCZmxbJ+?=
 =?us-ascii?Q?ep4PNMu4mv7++eUhqvZQ31eK0xR4FWTRlFsG7McYB6YG10TduZKccDjvNHly?=
 =?us-ascii?Q?Y0/lMZcXVaPp/L1K9zbwvmAMXcvkQGg+dWmT6etvF4bbaVSAq/KIxStLOqur?=
 =?us-ascii?Q?cldhWsWjXBC8iFKmumLcFWYsZz3F6HXVRogJMkOhxO+v/iVTVUHh099GouDQ?=
 =?us-ascii?Q?Ni4FGGjCpLaU9j4TB6Ll0T+jGu+dw+jqizARG9hmaTYCKBbNPthzVYddgH/E?=
 =?us-ascii?Q?9rYvk+6ds0mUKNqcFOyYpXZ+9mUKh6VwkohDkScsfWGYf+GkXCeXdYB8Bwl2?=
 =?us-ascii?Q?M09d2RVmbG1lSK561ef9lvFzeHizcfsslBfbE+whMSuKgFuaYKgCw1CjYDCu?=
 =?us-ascii?Q?aiYYC+lcqASKZ4tmeKQATWAB2ZANMEBTNxDSFl4fqWZoNzKocrs8cM5dDOd6?=
 =?us-ascii?Q?0nNpgfluERAii08NV+DvG9mhQMEexS4XuRaTlPV9j69lvAsViDX3/eGGD6xz?=
 =?us-ascii?Q?vgCw9PCxq4m23UbRFDfnlprpA/JCZECfrXN+P4Cz5UfPDbhJo9PlvbOqVoKG?=
 =?us-ascii?Q?7RX8WY5PdzlG6l8dJ2zDrWOxPxnYFrWTKdjwrXCL+OpnwBDVJuDJ8c/nYI1b?=
 =?us-ascii?Q?Mi8jpqIMLL9m1OpcZ+3b164I9hwEEWSVkt1KbCtW3eNbi8rsJXOPT54/r3mg?=
 =?us-ascii?Q?5bpL8Tpret/xCxbsGfNu62ocf6TslLEzrpEpaTwK/whBOrIVMS9V3GEXoJC8?=
 =?us-ascii?Q?sxpKSK0vIKRbj71EregUNoArxsZd58Yi3fCvawcuTETe7svxIDRn2j8PIg9Y?=
 =?us-ascii?Q?43Z+eaJBITeM3EqP6hciLNlyo+dT2+LiMIx+hW1ES7gvJztLb6PLNoItwGAB?=
 =?us-ascii?Q?Wm19hweCqKyX+TVCIy5FQFDGziiuhRCBBEonfv2NlUWw+CJ2DCceN0ynXyZk?=
 =?us-ascii?Q?S8YK20x27ZvEiqWrRaIuvcU93NOcCjVHH4sV2MhZ42vFl+InTlnScgTH1yk3?=
 =?us-ascii?Q?bcjlNl4j+gBoP0T+7dlHCmbkLJlWD5EWVw4RIodiHYxET5vMNva7GdPvqG+T?=
 =?us-ascii?Q?iqtODSdMkQdHjpp0EXsns4pbwJQt5cIj1a9w2Aaeu9phj0UUOBBfgZnKwWwK?=
 =?us-ascii?Q?jIcnxGNS+s61kE2kTYkCtbtJIcW5jA0bD9H7kRPrj/3nNncTb4iyj3Cg5cpC?=
 =?us-ascii?Q?DCiUmCbYeUxAqAya1uWwuvyT9mrMGp8O+Dnt7lnpXGMQnYxN2cBabDQhmCqw?=
 =?us-ascii?Q?2x5zOnQCefj1LgPMiFUGn0lfww07EL6gN1b7CzwVueGUh6Stck6zVoOBD7J2?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 f+EIyRxozSqO2ZNNpmnJZgAKA7FznQdiFKmTr7w5ba6bEr0Xk+rIVzqPulCHXlI3JGrpXj5J8AF6jICvKBC5Ws6PSo4x1gRFSYSBrsTm34zp/L8BuFOZqkTCw2rJE2wkFxbg2DW+MlBCzBAnQsDdwstu4kpSfeWSNxZ3wYcodkHKKqI6wR6kn0P+7BsVvWsQEHuXfYumyS2b5oUnWH9qdST1KjyW0vHFg/WFSySotydN0xrxBjvn58/oZlHS+Z74/IZtIiTDj0TZ29a/swxaDhnyM1v3IaHUV3v7r9vBHKMm9fbLv+Pj69Ni07/uwjQtuEWztXgrdLrIrirO8Sutig6gdWzoTQW5wCEJos7+3BPP8mGL5orqkzmcOG1GoYHxy5wX9DoFU6PKYT7DSehEUbfywDMhkErfuGI7ynWjgUR0zEDGQkVF1/HYeOfiYj/e/trXllA97nPfelV5xP2rkqNsIlQHFLzgD0N7mlTc9AOiC0+rg4/GVc2yPeQpzGAe3Krs7g04rDsBv4yJA6SebiJFLUEEyVWa05SnEQLDXWgjmNZ+zHrXF7i21Rqd8h+cnijYUhQPkoRy7sLA7VXTjo1Y8DRbYR7K780Dt5zQk8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f01ee09-cc51-48a1-4d11-08ddc069221b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:13.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHBBedF5ZJw42i4XRCFd3ipB70AevJvfYKy65pg58nqMKCUemt9wPw26ihjMWVjFMYX/eJpxzXa51I44BapTfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-ORIG-GUID: 3rg09HVB5DO0gAFCVI7Kl6du4hAc9ybt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NyBTYWx0ZWRfX3lJ0UvcIz3G/ 1NS25fq4NlEtE6YFRl3F8MsEx6W9AMtPjsfwUyy1NU7W2GOZhiQsho0scKEkQ8aZfxAde2xihkJ L+AegOAcs5lWzHP/DtWQ8R5Qxte1rXe8mrERJZe9noxIhxBk+ELIVy70ytTpYZg/Hdt1SVQLiF/
 1Tce15ejaD9yMOnuAOUuX/rMj4yNOJsEOvHiEoCNs12xe4kpx8+IeGe08AXE35kpGFuSMX9gj89 QhdMT6WNh7oLK/MkbQYzQEJ6eCrpHjFU8DlGh0oxdSPgAQqr7KWYPzTyH+TQ9wokngBRRxxPa4P lsHKvavhMU9FnX595VU7r6iNFj9jh2DDKo/3aspji5J14Qt0AUAiBK/EFoktfw0KPUDxTBLD6yW
 gB29JMf8H6G6xQCF96W6em4vcb6Z8MlE3pWInHbcZnFsuVU406RtHaM5Y3R8SYuWy8eSsOPW
X-Proofpoint-GUID: 3rg09HVB5DO0gAFCVI7Kl6du4hAc9ybt
X-Authority-Analysis: v=2.4 cv=ENYG00ZC c=1 sm=1 tr=0 ts=6870ed33 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c220..97065bb26f430 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.43.5

