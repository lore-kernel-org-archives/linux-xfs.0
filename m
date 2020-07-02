Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B55C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E0C207CD
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 12:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=unibo.it header.i=@unibo.it header.b="Wrqva01g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgGBMPN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:15:13 -0400
Received: from mail-eopbgr120103.outbound.protection.outlook.com ([40.107.12.103]:13376
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbgGBMPN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Jul 2020 08:15:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbCWEaGhSYnujCMUxfOJU3ztm86DHsHffWC5EYaz1ZNek3ZwiSkhD58XyzotkqVuYfx+duCC7NgN5wZg7e+OXzjEqqsszxKqod2sPPok13NzUb/Tb+hL9Zd7RCm1jZakzoCEmmmwf+cnuJSFamct35cYzgYutEY9S2OzzleqOIjysjDPgBi9gnSFpgRZkGADFWU8KQpkK40g1F0pZDyFw4oRprqlx+JwUofNkh+2vr+fVRCp1fi6syraUcPZ21PSwzEhVXLzr9oZlo/WOF3B020hHOI3KaREqzt4lrlahK1dO+zmEd/j9ziLpiw3of32t1AD3CKSoh76snu1utkR1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31jQyV8GxC2MMEON2/zhsrmFQtNqjLriCJSwu0S116Y=;
 b=HDWNvB3LorSs1oy7Cr+zuUjxybxR1425dF7AjlvuduJcYWrQKzQmioVAgn0C+LHtgZk93rBWR0+wnf+8v1ODsA4u+O8UxSW6dKYloh/HtTVbCSxUtLScyG2QUcPMwBsI8vsxk9YOOofWHwCj5Fdz7NXunKn5SeD4AJ2JC0bHEum0GopdqsnNx03rkUu43nq/Pxw2lnQAgs+nRLmx3SZzecIHABRtU/d6FDKs1EqlnoUVY2mBIWbzn1PYyua5W3OcY0LzSA2hanFRVwXnQEovYHRTazFQWOyInbqi2okb5RGyy2Ae5irxfT+EUWLtuwZ3sGm+KkZcVoYX5Bs5i2mh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.204.25.93) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=unibo.it;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=unibo.it;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unibo.it; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31jQyV8GxC2MMEON2/zhsrmFQtNqjLriCJSwu0S116Y=;
 b=Wrqva01g+PPPaP8x32CdM85G4TY5K/B0Ba0ut9OjK+lW/dJ4YxszE5/JmqjWlAh+67xciSROp+cmRwiQAJJqKrGr9TOyvS6kT/6GfMJdg5tCssSgyKhirqFzd782k9sbqF00fQvHrF7ja2VUKtrOwmMkJZceAhBfWfzBcJny3EI=
Received: from DB6PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:6:2b::27) by
 PR1PR01MB4955.eurprd01.prod.exchangelabs.com (2603:10a6:102:3::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Thu, 2 Jul
 2020 12:15:10 +0000
Received: from DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2b:cafe::75) by DB6PR07CA0089.outlook.office365.com
 (2603:10a6:6:2b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend
 Transport; Thu, 2 Jul 2020 12:15:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 137.204.25.93)
 smtp.mailfrom=unibo.it; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=unibo.it;
Received-SPF: Pass (protection.outlook.com: domain of unibo.it designates
 137.204.25.93 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.204.25.93; helo=mail.unibo.it;
Received: from mail.unibo.it (137.204.25.93) by
 DB5EUR03FT013.mail.protection.outlook.com (10.152.20.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3153.24 via Frontend Transport; Thu, 2 Jul 2020 12:15:10 +0000
Received: from [137.204.51.32] (10.12.1.55) by
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 2 Jul 2020 14:15:04 +0200
Subject: Re: Separate user- and project- quota ?
References: <93882c1f-f26e-96c7-0a60-68fc9381e36c@unibo.it>
 <2c0bfee3-01cc-65cf-2be1-1af9432a18be@sandeen.net>
 <df054c4d-a1e1-2425-3319-dafa88fc9f08@unibo.it>
 <9c64b36f-8222-a031-b458-9b15d8e6831f@sandeen.net>
 <cb98acba-ebbd-5b45-36bd-0ee292449615@unibo.it>
 <20200702113437.GA55314@bfoster>
To:     <linux-xfs@vger.kernel.org>
From:   Diego Zuccato <diego.zuccato@unibo.it>
Message-ID: <1b7ed4c0-90f9-420c-e1ca-2af69769f4b6@unibo.it>
Date:   Thu, 2 Jul 2020 14:15:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702113437.GA55314@bfoster>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: it-IT
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.12.1.55]
X-ClientProxiedBy: e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74) To
 e16-mbx2-cs.personale.dir.unibo.it (10.12.1.74)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.204.25.93;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.unibo.it;PTR:hybrid.unibo.it;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966005)(36756003)(83380400001)(47076004)(82310400002)(7636003)(31696002)(70206006)(86362001)(356005)(6706004)(82740400003)(5660300002)(31686004)(70586007)(16526019)(186003)(478600001)(336012)(2616005)(956004)(6916009)(8936002)(44832011)(26005)(16576012)(8676002)(15650500001)(316002)(786003)(2906002)(426003)(43740500002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ef7df89-b08c-4337-dd99-08d81e8190e6
X-MS-TrafficTypeDiagnostic: PR1PR01MB4955:
X-Microsoft-Antispam-PRVS: <PR1PR01MB4955857A37FFBBE96434AAFD8D6D0@PR1PR01MB4955.eurprd01.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sAl0w7d0KWB77N+5hYYb3lznGMxw7WrWQFLlpFj4lC97bRwtTr4qGj1GKYhAElvrpQOychFhXXzlJDlMAiDjTlV5DrwGtwvDbKgJ2cPZ6jS7w7zfXDM8bUX2U2mpisw1oJoozmw3OCLfZqRJ0oruj5GZww0aTRD+3eiDSPp7q91va2Abygoy7lCYtzhiQY3lJbfJOKPd94KHOCJpGSQk6/dc14SAWM/50JmEDPtHUirHvIJlKSjogMG2CHjQTGOHo0LOTJ4MyX/GAWGWDA9xrEJQhfHBzQk/U9NorEaD6HhAG6Ez9iQxfTWLzbHSdUpMcusjupS4ElCkSuJesC8+ZHk51WNVKoeAFVZr8TSaYC/eFza8XvSqqUdPo7rVPPOAXuIssWX7tma1dnHVIcj8gz/Q0W4bnkuRGPHAzX1kqbJQFgpJQ4fVKBrpYawV8CPX
X-OriginatorOrg: unibo.it
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 12:15:10.2699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef7df89-b08c-4337-dd99-08d81e8190e6
X-MS-Exchange-CrossTenant-Id: e99647dc-1b08-454a-bf8c-699181b389ab
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e99647dc-1b08-454a-bf8c-699181b389ab;Ip=[137.204.25.93];Helo=[mail.unibo.it]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR01MB4955
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 02/07/20 13:34, Brian Foster ha scritto:

> I missed how this went from a question around interaction between user
> and project quotas to reporting of a problem associated with enablement
> of group+project quotas and an old fs.
Detected the problem and reported it as an "aside", suggesting a
possible improvement.

> The above shows a v4 superblock
> (crc=0), which means project and group quotas share an inode and thus
> are mutually exclusive. It sounds to me that the problem is simply that
> you're specifying a set of incompatible mount options on a v4 fs, but
> you haven't really stated the problem clearly. I.e.:
> # mount /dev/test/scratch /mnt/ -o gquota,pquota
> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
> # dmesg | tail
> [  247.554345] XFS (dm-3): Super block does not support project and group quota together
Seems you pinned it anyway.

> We have to fail in this scenario (as opposed to randomly picking one)
> because either one can work for any mount (presumably wiping out the old
> quotas when changing from one mode to the other across a mount).
So that's not possible because introducing such a change would create
problems in existingsystems. I understand, more or less: if they still
boot, they're using just one option and from down my ignorance it seemed
a good idea to just discard deterministically one of the options
allowing the system to boot anyway. The usual "it's easy if you don't
have to do it" :)

Tks a lot for the clear explanation. Today I learnt something new.

-- 
Diego Zuccato
DIFA - Dip. di Fisica e Astronomia
Servizi Informatici
Alma Mater Studiorum - Università di Bologna
V.le Berti-Pichat 6/2 - 40127 Bologna - Italy
tel.: +39 051 20 95786
