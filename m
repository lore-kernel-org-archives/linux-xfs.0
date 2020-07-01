Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02629C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CE92074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=unibo.it header.i=@unibo.it header.b="dJnYduaA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGAIlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:41:45 -0400
Received: from mail-eopbgr20108.outbound.protection.outlook.com ([40.107.2.108]:34051
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726670AbgGAIlo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Jul 2020 04:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DA5KA4a3CGzl4GseiHhtBpmSC8DguYuHQ8bLu8KaHUonDkMiC83lRBjTbWaD4csrWa7Py7bxwpex8pkVYJsyg6hJqXEQRBlaJVYC2JeZhy/22Bbn3xfDs5FXTg+nqQQ0mCizb1uYPtaHEcVnx4N3HJWKYbLcPWTNlMus9IVcSbvs5SYS/bSQkh8OaBDpBzwhhUCFR3JqVMKk8DH92kPqI3ENb/9mJjOBRAPLFfOGNo8YywRz3fJ158g1OBmgj6UfLc8av1qTT06lSxj1JjHUiwtEzPicgZBeQp4Y+VMsybWA6dOgP/K7AEcte3IHSzEubFYcBV/zO/bwaK5UPG2iCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWenEDUV+3zuWSbRb/HSFccjTivLrIvAApoDSqJ9IXE=;
 b=h0vCl53HLv2bK+U31OE+6uG4YktkBb/SP5OIG5r0h55XcMnUC2wfu4zi2MOUWNWn5BZD4YxGMBjaLBJBLjn4DzwPfCuf9t6Mp+0F4TDSFv7tHJ/F7XDGmECgkPnW2ACjwg1po4uMw0fGZRkOGryoW1kJuXSrs5LUhx4MAzECyjj1CGdp7sAlIqS7THD6IGdBybrMSun9QCs3pboGAa09H6n1fKDzPPzqAQdeBHc7Y4zKVqpeqUnH7ev78BOq5D98MQeSPmtoTsQcsP8AXVwpkEhJ+L0BZemU8H1y0eVe28mQw+po0fQHsrySXxJ2AwkwWx8IHGs43hD3mP2bEaDKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.204.25.93) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=unibo.it;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=unibo.it;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unibo.it; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWenEDUV+3zuWSbRb/HSFccjTivLrIvAApoDSqJ9IXE=;
 b=dJnYduaAAk27LyHMPkTfXqf85l9jtuGIWw4ivLjfG8bTY5+JSjoP3G9oZX0Q/9KCTP2Dr4Gj8OmXJZbRj0b4UkDskp1vra7suQWNp7dq2qKO5RtoPML7oYEU5tHKEUAKGw7FUaUunOYW5L77sNKSk4fK9tBsZDYfXmQG69ZyT0I=
Received: from DB8PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:100::41)
 by HE1PR0102MB3148.eurprd01.prod.exchangelabs.com (2603:10a6:7:7f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Wed, 1 Jul
 2020 08:41:41 +0000
Received: from DB5EUR03FT042.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:100:cafe::3) by DB8PR06CA0028.outlook.office365.com
 (2603:10a6:10:100::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend
 Transport; Wed, 1 Jul 2020 08:41:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 137.204.25.93)
 smtp.mailfrom=unibo.it; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=unibo.it;
Received-SPF: Pass (protection.outlook.com: domain of unibo.it designates
 137.204.25.93 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.204.25.93; helo=mail.unibo.it;
Received: from mail.unibo.it (137.204.25.93) by
 DB5EUR03FT042.mail.protection.outlook.com (10.152.21.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3131.20 via Frontend Transport; Wed, 1 Jul 2020 08:41:40 +0000
Received: from [137.204.51.32] (10.12.1.55) by
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 1 Jul 2020 10:41:40 +0200
Subject: Re: Separate user- and project- quota ?
References: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
 <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
From:   Diego Zuccato <diego.zuccato@unibo.it>
To:     <linux-xfs@vger.kernel.org>
Message-ID: <df054c4d-a1e1-2425-3319-dafa88fc9f08@unibo.it>
Date:   Wed, 1 Jul 2020 10:41:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: it-IT
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.1.55]
X-ClientProxiedBy: e16-mbx1-cs.personale.dir.unibo.it (10.12.1.73) To
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.204.25.93;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.unibo.it;PTR:hybrid.unibo.it;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966005)(336012)(44832011)(47076004)(2616005)(426003)(956004)(83380400001)(6666004)(16576012)(26005)(316002)(2906002)(6916009)(82740400003)(356005)(8676002)(7636003)(786003)(36756003)(6706004)(8936002)(478600001)(15650500001)(4744005)(186003)(16526019)(70586007)(5660300002)(86362001)(82310400002)(31696002)(31686004)(70206006)(43740500002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdabdf72-6804-4f0c-56b6-08d81d9a935c
X-MS-TrafficTypeDiagnostic: HE1PR0102MB3148:
X-Microsoft-Antispam-PRVS: <HE1PR0102MB3148C5CAEB78320E7226841F8D6C0@HE1PR0102MB3148.eurprd01.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKsqqIjcAmP2pnxyaEOUymfpcQMf2yfvE55ai9rV94/C+x3dnb/RhomNqvOL7Q1t3mRAicUIC0ckuGs5d+zFRpFgoOEWX6fuuj1CAiZoOCDnDm+RqQYRT3AoVmLdi7jc2zH4CG7gIAJc1S7dx4/YRCBcuTbTOCgbqUSpzXT/4yLFQ0feO+NRhyseY/iCuoteRrLhyisY3iOLNVFtp4w8ChuUfR1N5UVnBfMgqOOCUWzPkHu4YO4UX8N/NzqM42CxwtguupdJ/t4+d1KgNHncq4iliMmiBcVF8nOEqYowjtgUEHQOoz5PhswKORDLQtmXM50bzqRnpasFyHNvpGrKXOAjYR7QEHQHJCjaUCHFZFAMHg1RtQK8IbRomn6+zaj32UqP4QF0qM/7ZbAy1A25e1gKl+DUlxp1a/6GTKNUrWrlgWlIGnUmaX6tOrFHUr6K
X-OriginatorOrg: unibo.it
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 08:41:40.6466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdabdf72-6804-4f0c-56b6-08d81d9a935c
X-MS-Exchange-CrossTenant-Id: e99647dc-1b08-454a-bf8c-699181b389ab
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e99647dc-1b08-454a-bf8c-699181b389ab;Ip=[137.204.25.93];Helo=[mail.unibo.it]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT042.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0102MB3148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 28/06/20 20:22, Eric Sandeen ha scritto:

> I think what you're asking is whether a file in a project quota directory
> can avoid user quota accounting, and I'm pretty sure the answer is no.
Maybe it could be a feature request :)

> I think you'll be limited by the first quota limit that gets reached.
Verified that. :(

Moreover, I've had troubles at reboot because the superblock did not
support both group and project quotas. Didn't see anywhere in the docs
you couldn't have both enabled at the same time. Maybe i'ts just because
it's an "old" filesystem (IIRC created about 10y ago). I'd suggest a
"graceful soft failure" in that case: just emit a warning and
disable/ignore last option requested. Recovery of a remote machine would
be way easier :)

-- 
Diego Zuccato
DIFA - Dip. di Fisica e Astronomia
Servizi Informatici
Alma Mater Studiorum - Università di Bologna
V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
tel.: +39 051 20 95786
