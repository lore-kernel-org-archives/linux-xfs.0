Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD05C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 10:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07000206DD
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 10:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=unibo.it header.i=@unibo.it header.b="cF0/zT/5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgFZK6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:58:44 -0400
Received: from mail-eopbgr80101.outbound.protection.outlook.com ([40.107.8.101]:21918
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728161AbgFZK6o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Jun 2020 06:58:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4BUAv7nX83A/DPLSa+f1QV1OQxtuAwEBr8Z2PyrG1pqXb0MC0MOSftUU28HtPs8GO8YkKjEkvd8V3TeAz2Ny/VVoGfe0Ua4ttlGOPde82uMYkezohzn+mqmmMMRgWkz9UQyV91fhqW9i9p6iWH2U39Ag+NeFTauhxMyI+do8Lc1K7QUeJZzUcVI6ziwr+2eDaM3GirS40FJAS+QLgon2z9gbT4nLYQeuDP6g3mUU4DIsouS5/01GOENumlDoHO3t0SGVtvUQ4dWQzLmOxl0PnKJkyj2U/eaOMWRhUQcT792OPsv4drE/FQJLD5RgFnumU5qqGlqXEt1KVXk7r+rTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2hsYZSUZ1NITeM0CfY9KhsVW+orZOtHd7sEyZOTo/E=;
 b=Emd47B8wgaZBhURHjwy9cOT73EoINGymKLsohCeq4QCCwdhBKckFCYUfJtlDrcT7Emnpigw4rPv6H5P0tdHkFdLSxkJJt8A567OMA1+zRrAGvlrnUThLhkSoL58f7HZ+WLJkQsGM40V+a7pcvx+1q+AG6BraWIr8laUv9SNfPiBiNF0kz6Htn6C6Cdft/JFxnGUZ/EKMXb+8QHyqoHP0Qi1ynp1JSjCWxCvnUHE+SKuUoIqQcTU2CEmuUlfsW8AlYa4KVXwS6aQwcBBa9Z2cBXtSBAt4fGYZa0eJdFHcQQvIJ4vTAH4IRXXRloJBlWUPjSFCcUUui3Ty+hr1Co9NOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.204.25.93) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=unibo.it;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=unibo.it;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unibo.it; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2hsYZSUZ1NITeM0CfY9KhsVW+orZOtHd7sEyZOTo/E=;
 b=cF0/zT/5ngKPIRGO5zaRsqNAzkQRERJJNlq4TJ9fM4N/8yKD9R48Y7AAlY7iQXhPBAgGBrgIzjBfMmhFwm6bDKywjsFKvDVaUExVdkWJBdF3fJReMEoz91SKAjIw/PxeldmKu/A0s4SB7ZFHrsqEFo2AamV/N2aUt2vEAyd+4BI=
Received: from AM0P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::22)
 by AM0PR01MB6514.eurprd01.prod.exchangelabs.com (2603:10a6:20b:16c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 10:58:40 +0000
Received: from AM5EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:190:cafe::6) by AM0P190CA0012.outlook.office365.com
 (2603:10a6:208:190::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend
 Transport; Fri, 26 Jun 2020 10:58:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 137.204.25.93)
 smtp.mailfrom=unibo.it; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=unibo.it;
Received-SPF: Pass (protection.outlook.com: domain of unibo.it designates
 137.204.25.93 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.204.25.93; helo=mail.unibo.it;
Received: from mail.unibo.it (137.204.25.93) by
 AM5EUR03FT041.mail.protection.outlook.com (10.152.17.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 10:58:40 +0000
Received: from [137.204.51.32] (10.12.1.55) by
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 26 Jun 2020 12:58:40 +0200
To:     <linux-xfs@vger.kernel.org>
From:   Diego Zuccato <diego.zuccato@unibo.it>
Subject: Separate user- and project- quota ?
Message-ID: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
Date:   Fri, 26 Jun 2020 12:58:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: it-IT
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.1.55]
X-ClientProxiedBy: e16-mbx1-cs.personale.dir.unibo.it (10.12.1.73) To
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.204.25.93;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.unibo.it;PTR:hybrid.unibo.it;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966005)(7636003)(82310400002)(336012)(786003)(316002)(8676002)(31696002)(6706004)(356005)(83380400001)(8936002)(47076004)(36906005)(16526019)(16576012)(186003)(956004)(2616005)(5660300002)(70206006)(4744005)(2906002)(44832011)(70586007)(31686004)(36756003)(478600001)(82740400003)(6666004)(426003)(26005)(86362001)(6916009)(15650500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 759e3f8d-875a-457d-3dc7-08d819bfe2ba
X-MS-TrafficTypeDiagnostic: AM0PR01MB6514:
X-Microsoft-Antispam-PRVS: <AM0PR01MB651407781F7D9C0C6768EB688D930@AM0PR01MB6514.eurprd01.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akKp5OBpKqMMB+dGOGYLeige7U8IWB73DAnoXw1YMfBtegiG8wp6mzrAl8CjwLN9FvjOBgWTDtuS4smW/eG6vDYu+tEAYAGW4sjPzSNSzY63xdOECQRYwVnirnuRU+3hKn00HjZzIgsinXIJPHATqwOFahtVm0VMuFgy5g/QHVTHcvGBc5C+Ex0udxQ8ue1kgFbvf+ZS0MGjhhy8N3Rg57RTbqfBUcitXpaqNYpY8O3h17shPDjK+aC7g0797RvA8km5KnIxnedstFb8WA3e25AauIC7TsFGiG5ChCwjjWV6MiaQFd9Ddvsvz4fwoLSIcyU/H9Zy9wjAM5U/6+y0tFvQpehkUnWdF4NBV98g/hANJx6ilWL3jnIYFHaF3p7Mmem2Gd0afbcC8usQCA3S3smMtd1JnZEHJa0yHUFRx5AGHh02kFMrg/3f2ninKnWo
X-OriginatorOrg: unibo.it
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 10:58:40.5589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 759e3f8d-875a-457d-3dc7-08d819bfe2ba
X-MS-Exchange-CrossTenant-Id: e99647dc-1b08-454a-bf8c-699181b389ab
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e99647dc-1b08-454a-bf8c-699181b389ab;Ip=[137.204.25.93];Helo=[mail.unibo.it]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR01MB6514
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello all.

I'd need to have separate quota for users and projects on the same
filesystem.
I currently have /home/PERSONALE and /home/STUDENTI where homes gets
automatically created. I'd need to have /home/software/prjN directories
with independent quotas.

What I've seen is that if any user creates a file in prjN directory,
that file is counted twice: both in user's and project's quota.

Am I getting something wrong? Missing an option? Can it be done?

TIA.

-- 
Diego Zuccato
DIFA - Dip. di Fisica e Astronomia
Servizi Informatici
Alma Mater Studiorum - Università di Bologna
V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
tel.: +39 051 20 95786
