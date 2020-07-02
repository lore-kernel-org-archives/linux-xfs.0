Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3652EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 06:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D901A20B80
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 06:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=unibo.it header.i=@unibo.it header.b="SFLhGrAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725263AbgGBGON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 02:14:13 -0400
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:50721
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725774AbgGBGOL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Jul 2020 02:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta28BscLPsRIBSEjwauMUfbZEb78OlEw7EKLQmuE1J7Zvgr0g4tqjg8TLZLUoVe7VwF2c4BaKxBdIDC8viWhrU5Drww0Rw4XjSVLOC2XH7L4hQrh+GoQUD2i5rTL+em30P6iV5XuYsRgsvXsgr3ja4NMNTZciz25tDq1DOeqhd5+3YHVfhzh+bzlKcUDQBNpGLFIjEQpp8B77u1+yBl5W+HjRNOlRFGZ6SoRdnyL393PKj0KsH3J/OhCl/85ORCtA+vyecgr9fy8Iyiqk2e6XUaaPxMH1VUh9fJP9REGAAOAryxSvOFHFwpNa1CLngdFdVe7tiYH/v/zcl0PT2hh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rg7yMBYQZp//5G5rIt73gWwNK4W1iXgerNIE+jZ0qso=;
 b=DzvqNo9cvTAKZCHnTcD5F7ogskYjm1p0l/zUcHrwr0MnhGG4Y2i+osKDPZgThQlqTDwH1Bn1evQ8kqrnrUiISVlkqtjB/aKA1+MtJyBVTs+LbY3i/gJOfxgHUtXqaRJUsW9RU8VLj/Ldbt+8TaWQHvSEF4O563gOyFBdUFG3yjEh1v5BF10CWc8ZCTaHMxziZa7nzV6d/AfHN0bKXMoaLBrEXTP3KARd2ucgV9hVSLNGmNL9ycZVerhweOAs4WWdu5zhQ2bBHGirJowjs/FuhGU+HUrIVKnxCHAbmL5HdSsPUNXr5E2xXjDj/J/jkMqmJ+73BvC9tvqrJ78kznG8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.204.25.93) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=unibo.it;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=unibo.it;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unibo.it; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rg7yMBYQZp//5G5rIt73gWwNK4W1iXgerNIE+jZ0qso=;
 b=SFLhGrAZ/4B1ISCZB/LGCOt5l69iNrA2V0ctH2TVf5MTTGaexfBR17nPEu77bFEAYjB8XCe5JXXUPHfduoYUWFRxB4Y+CK9+EIul74rD90uV9gtX7BQRvA3Y2ETOUY5EzkLaCRt9zsN1Fy1zGx2/T/RrlgI3xxILfGmPfao5Q6c=
Received: from MR2P264CA0004.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::16) by
 DB7PR01MB4426.eurprd01.prod.exchangelabs.com (2603:10a6:10:6f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Thu, 2 Jul
 2020 06:14:08 +0000
Received: from VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:1:cafe::3d) by MR2P264CA0004.outlook.office365.com
 (2603:10a6:500:1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend
 Transport; Thu, 2 Jul 2020 06:14:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 137.204.25.93)
 smtp.mailfrom=unibo.it; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=unibo.it;
Received-SPF: Pass (protection.outlook.com: domain of unibo.it designates
 137.204.25.93 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.204.25.93; helo=mail.unibo.it;
Received: from mail.unibo.it (137.204.25.93) by
 VE1EUR03FT044.mail.protection.outlook.com (10.152.19.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3153.24 via Frontend Transport; Thu, 2 Jul 2020 06:14:07 +0000
Received: from [137.204.51.32] (10.12.1.55) by
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 2 Jul 2020 08:14:06 +0200
Subject: Re: Separate user- and project- quota ?
To:     Eric Sandeen <sandeen@sandeen.net>, <linux-xfs@vger.kernel.org>
References: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
 <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
 <df054c4d-a1e1-2425-3319-dafa88fc9f08@unibo.it>
 <9c64b36f-8222-a031-b458-9b15d8e6831f@sandeen.net>
From:   Diego Zuccato <diego.zuccato@unibo.it>
Message-ID: <cb98acba-ebbd-5b45-36bd-0ee292449615@unibo.it>
Date:   Thu, 2 Jul 2020 08:14:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9c64b36f-8222-a031-b458-9b15d8e6831f@sandeen.net>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: it-IT
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.1.55]
X-ClientProxiedBy: e16-mbx1-cs.personale.dir.unibo.it (10.12.1.73) To
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.204.25.93;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.unibo.it;PTR:hybrid.unibo.it;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(46966005)(2616005)(786003)(70586007)(6666004)(110136005)(7636003)(336012)(316002)(426003)(15650500001)(44832011)(31686004)(82310400002)(70206006)(2906002)(82740400003)(86362001)(356005)(8936002)(83380400001)(26005)(31696002)(47076004)(16576012)(36756003)(16526019)(186003)(5660300002)(956004)(6706004)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbb0cc76-cacc-4690-62d9-08d81e4f211e
X-MS-TrafficTypeDiagnostic: DB7PR01MB4426:
X-Microsoft-Antispam-PRVS: <DB7PR01MB4426066BEF2298B754987C548D6D0@DB7PR01MB4426.eurprd01.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46jW1S6/Xm39eoh+B7tGNk3vNdZn1Li6kUIO53Rp44IRdLhcRSogp5mZDM8BD2P2Cv3ya1dbHixREiAnGaglFtjehmH5Tt2Qr+FVGyqF2+XW1Kp7JCi2B/FgrPRvvYDgoHpNYdy886nmRXJsc+LCnRqAsrc1yEYC/OXlYKL35axqe9A17OtFqByYPNyTBNT6twgW8NC40og/cLOThhr36qllpM2fjujd5Trr1UCVMZv5qNrX9wbmisfsW3lKTeG5oYOS5iwB6eti00fdFkHHgyEy2fM3dmOIdCN/Cg9V1vE3a+Jmj2hMCwStnnTv2awaPmPh6OQbuLak3RmiksKR9GW3eZLovMu6tGi5Cm7eATZ4xrrW/6S4gdMWYtFP+NyMtbTcEDMLkDbJxxqXAD7glMj15hLdo8NQH+vxD72XT3bVcypvcy1HUzzuDMEzvjil
X-OriginatorOrg: unibo.it
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 06:14:07.9124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb0cc76-cacc-4690-62d9-08d81e4f211e
X-MS-Exchange-CrossTenant-Id: e99647dc-1b08-454a-bf8c-699181b389ab
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e99647dc-1b08-454a-bf8c-699181b389ab;Ip=[137.204.25.93];Helo=[mail.unibo.it]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR01MB4426
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 01/07/20 20:46, Eric Sandeen ha scritto:

> Hm, yes, worth a look.  All 3 have been supported together for quite some
> time now, I didn't know it reacted badly on old filesystems.
> What did the failure look like?
Boot failure saying something about superblock not supporting both
group- and project- quotas at the same time.
I think it's related to
XFS (dm-0): Mounting V4 Filesystem
As I said, it' quite an old fs :)

xfs_info reports:
meta-data=/dev/sdb1      isize=256    agcount=41, agsize=268435455 blks
         =               sectsz=512   attr=2, projid32bit=0
         =               crc=0        finobt=0, sparse=0, rmapbt=0
         =               reflink=0
data     =               bsize=4096   blocks=10742852608, imaxpct=5
         =               sunit=0      swidth=0 blks
naming   =version 2      bsize=4096   ascii-ci=0, ftype=0
log      =internal log   bsize=4096   blocks=521728, version=2
         =               sectsz=512   sunit=0 blks, lazy-count=1
realtime =none           extsz=4096   blocks=0, rtextents=0

Too bad it's a production server (serving the home for the cluster) and
I can't down it now.

-- 
Diego Zuccato
DIFA - Dip. di Fisica e Astronomia
Servizi Informatici
Alma Mater Studiorum - Università di Bologna
V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
tel.: +39 051 20 95786
