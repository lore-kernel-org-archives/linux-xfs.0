Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A2FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 21:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiKKV4t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiKKV4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 16:56:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F047377E
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 13:56:39 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLl7vB008713;
        Fri, 11 Nov 2022 21:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=m3Xe7sec4wVl6QPOmIR7UR2TmBwUyAam8LU7uZHmq+U=;
 b=Va3+TOnG0PzHRH4GGRnYLNAmV4VoyZXik3mZlB2gIsYaI+9kJFg1UkJOSdFUNF+hq/am
 cy+H+kMvxNJKSeM7QXsW2qdhpbYC0AmGSe1CibarqIGSD26RCZvpST3SYzOu00Exmy4K
 eStjOPywxZsqRNkhqhQ/OAvq7wwUP5QQtfnm0YdiiQzEo2luYLUdj4/wPpwgzIVp0ow2
 MHZtfUIuj6+IzHn/FpX9EeSkDX8x6EV7XnqsqNLQ9p/1uiqdxMChrKMaa304QTJ288x4
 lqJ/Itsy/OFALdKfMqAApdXOYcT34aOScXJ5zyafbOyiG+rln2Y0yUaa6/Wh9s4kh9XG 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksxkx00cm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:56:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLQB1I021585;
        Fri, 11 Nov 2022 21:31:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq6ufe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:31:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK+wGI8oNZYElMKxq25+OsvfVbTQKsMaJnTEc1vUMo9e6fge6BFY0kq8JaNuqVaVUf6XLkj6ZjrWwijU5ruYZKBVAtPU/D1yFvFyE5YmOVRRZnvm4FV9KZ/6VV7ZjZMkPpQ2oBI18L9P9IVtMD8td7evu7iI10f3NDAOH5VM/dUcs1QRA0tHq5r4/9ZZfVGpdHIP+2l4Vv8suMmSuDeNKSimYP+uiePsTPhsJvulcX9TWfxunUrrnSeebZySkHWSkLtm6I3C3Cqu0+C/mM6zsrf+T3hd2ZrBhhbdlK/dRe/LsiqECEGKx2o0E1tF6JeA6ycPER1WqR1lFkPKwJu6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3Xe7sec4wVl6QPOmIR7UR2TmBwUyAam8LU7uZHmq+U=;
 b=CK8JkTfxyRC1+SCJwGBegKWyPyHIVqaYjLaLKXGQIPc9f/vLvWtFmToDTTwKXh6r+VEB0yPpwccWLuAzh3QgAP3OCwAP62dr1fIWRC9cYAjGeZkjZE6UjHJYv+eqMDlAMFS5XI5g+5tyLmA/FrfvriLHaIu7w43nIga2uIXWmyEP0Xod59pOumcBb/TDESTXHtM0WViPt2v8rlHLFzVD/hbgKtSA42Wq9NpNKHIxdGjoy1QRnLWZt+PzXUfsMY8Tm3xatl4WdFDOpHc2VBnLv9gDTyp38yN683GARp64WWlzx20BPj7yKgPshqrItPvdwIasrVc7/dV/hhgq/q3zHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3Xe7sec4wVl6QPOmIR7UR2TmBwUyAam8LU7uZHmq+U=;
 b=DGeXaXfDK4WEPP9BvReQbD0FHp1rCgdDyM4V4nzzwuN67mmfpmsBYyaloQzDyjxVf56A8dkcIrhPJLo9siTs6gQTb/76AvfIcF1PbxTaPnDMQE1uIdv3INv9P083e5HyvgUxKjEZe73S4c44KAOgY7IsiJmeeXbFpVPTEoWCoEk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 21:31:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 21:31:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "tytso@mit.edu" <tytso@mit.edu>
Subject: Re: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Thread-Topic: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Thread-Index: AQHY9ImpxD+40FyfSUKJtL6nirulHq46QN4A
Date:   Fri, 11 Nov 2022 21:31:34 +0000
Message-ID: <01ededf2a3a1aaf5f4bfa841bffb8c3183374240.camel@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
         <20221109221959.84748-3-catherine.hoang@oracle.com>
In-Reply-To: <20221109221959.84748-3-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH7PR10MB6652:EE_
x-ms-office365-filtering-correlation-id: 9ad5ed10-674d-4df3-5a1b-08dac42c1b94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0mBSRUG/ydmJcI9u1mpIYqTITKAvZwnS5SOxJR/poGPe6gAYH58va9QfDw6AE1pkHCkLLh3+k0WaMMYP/AjZpQYsFjuRoWItdoDiuC7hIU3taxSBDuqkkRxwkDE/P7wUmOWYeFVvsgpxdM4Fz6ZFEOA+HZ0tUZO8+a64Xy3NZW22X6iha54TdG3LcB6hYvdVcOZ7G97QNUL9DAy67d4MqG/n7peQKtIYIUwCPAuwpbWR9pxWObd/Z3I6LCuOcXhQCxCds4Do8T29BYfMAD4Xxjr4XSZsZkalSe1I+oiE2WCY7GYQ9r9u13R0hFm+gOTa/pixI6xMw0QzIglxIhPS8YTe1Hh+cqWZUBi8i0R2crpk2QbpqnxA8AIX/jazEqcPtinKtb+BRkvauwyHSprcs+sw0SO/ALV3I9S1xPAt3dCH1hNVIT7uxOOnj5+2o2QQQlAv3gZ7hunWqMeQPR5CwA+BcibGFELlw4DHMraGy/vtJujAebaW8YeNhJl+diVcuSKUpgBJWum0wLqYF2z8a+ZRmpKi0b0kTX9Rt6NA1fS0YAIqjwl6x0nC7tZ1tmJfpoix3cSovLXiStug2iTNP5PDbxgCt4j7hxR4NjpkW6Unz/KKxSKKuFtY43boA86CxzvWS5wqda/45wnQ0osMhZPvZ8JaRYepiEiLO0S2qqLAyXHB76CjAe9441W3qn+QoGmgQlzQqcO25+p/b4u3sS+QzMVYpWq/j2DmxG+fwd1jK9wq9kq7TvEfDmTVYSJxbYLfjYiwSEjIYOChqOf/Cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(186003)(6512007)(110136005)(26005)(38100700002)(4326008)(122000001)(83380400001)(71200400001)(6506007)(2906002)(44832011)(2616005)(76116006)(316002)(478600001)(5660300002)(6486002)(41300700001)(8936002)(66446008)(8676002)(64756008)(66476007)(66556008)(66946007)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3lqbHdaMmFoK1ozWk5TOXZwTURpNnZ5cW9mZmV5cTExY1lFT2lONVBtZ0ds?=
 =?utf-8?B?QWVUa2xYbFJrNnJlU1haUlR6U3FEeE0zMDhJUWhHUTJTV1U0Z2dkLzhpWUFv?=
 =?utf-8?B?eS9vTnlsV0RaT2VTMkxJU0Mxb2ZlMkJIalhpRllyU2RiMHZSV2NoOVFCTXV6?=
 =?utf-8?B?YSt2OHVWUXlGZUpOS1U4V0l6cVVtNGxhT2xjQjY3MVJqZEUvamZFbnNVRXFT?=
 =?utf-8?B?NEhFOTYveG9JbmtIYlZ1eDFjVjREb0tuZEk4aU1BakdZTGQ2NVVDRGlJRzlr?=
 =?utf-8?B?cjI3akI1d0FQME05TGVsWUZXUERmSThXWHpGdXhVcDdnV0M2bGYweWZWNWhl?=
 =?utf-8?B?Tk9uMzlwTVRMOVcwRjA4RjZSNVNpM0ZHYlZ3YnRteXAyM1B4QUJuTHNCNTQw?=
 =?utf-8?B?c2RVeXM0UktMNldaaUdzN1JpR0w2c3NBQ2t6UWNreHUvdHZQQTVVZkpwNmFQ?=
 =?utf-8?B?TVNoTWRmaUZKaSt2Y1BTT1g4WHJNSFloaDJxYTVWa2o0ajNrb2ZGaFdYSjFY?=
 =?utf-8?B?U1FtV0FlaWNXdm5hQS8rQ3lLWTJscnBadVZQejRXemdKNk9iOEd0MmhZUXgx?=
 =?utf-8?B?Q0R4OHBNemxiZExJMnhqRjlIcnRDbWhiZWZzRUd3ZDFoNnYwR2lJUHNkU1Js?=
 =?utf-8?B?QU4vaGxEMVl2ajhWdDBNei90a0t3dEZoYlY0NnhaazBVZVJHNG9pd1ZSZXBy?=
 =?utf-8?B?Nm1kZ0w4QS8yRk9XNEc3amhneGtXbjIyaDJUa0k3c25ESjlQM1h2QjJlVkd4?=
 =?utf-8?B?ZXJsYzVHN2hkaXYvT2V4SUZHRW9GVlNyRWIxYnFaQUR1akhmUXZXV1RESVJt?=
 =?utf-8?B?M2M4WFAxbTlxTG5RcUdOVnZyclIweEtUKzlhazY1MldFQitDRlYxYjhtMVJE?=
 =?utf-8?B?TFVRazR0dDB1amRSczJvT2tvL1lrekUzYXkxRzl5azdXTDF4cXJOc00wemJW?=
 =?utf-8?B?MjE5OVZiU01FdW02V0xTTlBzU05zajBaRGNPTXkveTY0SE8xTU4rV1prcFk2?=
 =?utf-8?B?RmxlM0ZuOVlMSDUzZjdoZThJa3A5NllsT0R3bUJDSlJ4Z2tUaHZFNG1oSEpJ?=
 =?utf-8?B?T052OUZwQ0Z4aHRXbW9GUXN5cE5UNjlFWWVhb2lyUjdQTDJORkZiY1BHUHMw?=
 =?utf-8?B?ZStZSkRva0ozcldUUUc3VWIzL2ZiQzZOOU9ISGd0R1NOMHh3OFE1WVBWWFAr?=
 =?utf-8?B?b3MvSXJnQTRqTnZYR1lTK2FOVVc3aXlrMENTQ2RvWDBXNTF1YUROd1lDNEtY?=
 =?utf-8?B?UElIaVNtSi9DWGx0WmpzQ3NyOG9SY2szeW9yNWVyaEIwNU1zdWJjU09selVL?=
 =?utf-8?B?TzVqOUFIL1lhTW5pa3Q1MGRpcUhGcHRTaTZFSDRpeVBtb3VQZVo3c0lOTWov?=
 =?utf-8?B?ZmdNZ2hMVk1RVmNWekt5aXVLZklRd1dhdzA5anhtd0tuUXEvcVdZNXpxQVNS?=
 =?utf-8?B?VlZMeGRucGJ3aHFwaU4rejM4eUxDdkg1aDJpSFVmT04yU1hnclo5S1cyUTZG?=
 =?utf-8?B?aWs5cy81bDhZUEtoTU55OTNrMjFRYkxRT1F0VjBRQWhqRjY0N0tkdTYyVVk1?=
 =?utf-8?B?MGZkS2l2aEhWdHR0R25DYlduZXMyL1h4R05jU3lLT0dVa3BPWGFzOVlNQ2Q2?=
 =?utf-8?B?ZmcyQ0RNelFtYU5PZEg4M0hxUy9adnZXUndrZk5mdEtYNExmakhyY2oyOVFQ?=
 =?utf-8?B?bzkxdGIwbTJqbjVPMUgwY2Z1QWg3QmdBTU9LSUxNY3FhSWRxd2hHaW1RZDlZ?=
 =?utf-8?B?SXRCcmFHMElPZWhjUVlrWFVlNXZXbWhYVU9DTWpqbVNWWjdMYVhMeDlxTDRJ?=
 =?utf-8?B?NkxtNzVLMkFwM2todVNpS2d6QnVmQTlpbFVoZ3FJU2JPRFE4d3Y5Nm1mRFps?=
 =?utf-8?B?K3R1UlFlMk1xOEhNbUVCWUdhWldxa0FsZ04xV1ZpdW5hUGJnSkd2L2w2cnVD?=
 =?utf-8?B?WlZkQVliU3M1MjhvbDFWS1pZODJsZERUV2tuZGVrZ3RvdGFjblVOamxxL244?=
 =?utf-8?B?ajRQam4wS0lwajIva1pCcUlQaUlyKzdwSGtFbk9kVlo4MmNZNEZMN3JhY0g4?=
 =?utf-8?B?UXpNV01LWWNmZXNaSzh6NmtHRE81OGRTcUVqQjcyY0RDVVdUWlFXTDJ1bDJk?=
 =?utf-8?B?bFU3amZKeUxtYnlsOERTTGxWdzhKbmgwM3d1b0lwSm9yWFExZ3EvVzluMDlJ?=
 =?utf-8?Q?YiSricgmGR6dPSmnqy2d00g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA540F88E447B84A9992D6C66ABD5115@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: juFFqrZqh3GYkS075aGYrbMwIS2sOro2Y1jWQW3x1OywUTpwbXc9x458LO+Vy1Q6SCYt8F3hmwYk0oJbI2n14YG2xMEZCTOrr0imBz8uwidR7D+Ch6+IPlj+7GyqU62JSLArJV9KctDfGR7gkGjQ2ChssWrOEKs6xSKqhlQPzwoSEPeXFf7X2vKCjqdMTWMPbNSZrNGEy0bD/hXvxT2QGQfMpNvdI1DZLcywSPXNcB593x8Vn8bJFCkgaNLJBbNQyKDseDwZHb71tY8hx/gheSVzVl2zOeDS5h6QLPwCGafgVcEAz/5x5wY1Pwbe3RJs8ovu8r6V0KOHWbgePpQWv9XrKDtOk7AERMH/gPWCxPbOtHfbb9JYRH64t0xUqPfcpCrlprGTSGNJ68wuLzyWnjmHCaJCYcEftr1DrA4MFTdPX4/mxW0WtXP2D5sPJhy6ydfiHgAyN2oZypx9uTMBkiyzBwetLvihTq303sFtkze1IgIxafkdRM+a4GmCvVYLch9ttj2c+hyKKL6klT01yStqX6qM6bj3RJk/zdnyBzF1mgdx7PPcBvF8r3wNpDylrmxVwF2uJh1LmgZttkctO+Y50nYWrUAq5IAFjBgjC4Y7QuYOmxWUleCwPZPpVm8od+Civ/rKQCPRKQsuGGgl4Blj0/xHyfuFGgjgf3YIUSrSOcOVwv47vBuiZQicg3c9vUU9XP5IuNFMCsiZhGREe1QZFyURva6xOocVBjT7IM5JuUn/uiil9r7D+J4hOpkh+n5O+yHj8Rd2tV2I4bj3MKfIjG0WuQCpKyI78fQaZIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad5ed10-674d-4df3-5a1b-08dac42c1b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 21:31:34.6033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vs4asux5R5SU4uNFxUHeyK2MpM0CQ5MN1oHiv67Eb0Z+qlAg+kosxzcHBVG+qYMlWokZ6KXKXs7vyzGmLAtzD0KXk8//j8aixr6vkGW4AeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110145
X-Proofpoint-ORIG-GUID: JXVso_2BdOzjb3akTiCrUZuqPi8R3dO-
X-Proofpoint-GUID: JXVso_2BdOzjb3akTiCrUZuqPi8R3dO-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTA5IGF0IDE0OjE5IC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQWRkIGEgbmV3IGlvY3RsIHRvIHJldHJpZXZlIHRoZSBVVUlEIG9mIGEgbW91bnRlZCB4ZnMg
ZmlsZXN5c3RlbS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmlu
ZS5ob2FuZ0BvcmFjbGUuY29tPgoKV2l0aCBEYXJyaWNrcyBjb21tZW50YXJ5IGFkZHJlc3NlZCwg
SSB0aGluayB0aGlzIG9uZSBsb29rcyBnb29kClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNv
biA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KPiAtLS0KPiDCoGZzL3hmcy94ZnNfaW9j
dGwuYyB8IDMyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gwqAxIGZpbGUgY2hh
bmdlZCwgMzIgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lvY3Rs
LmMgYi9mcy94ZnMveGZzX2lvY3RsLmMKPiBpbmRleCAxZjc4M2U5Nzk2MjkuLjY1N2ZlMDU4ZGZi
YSAxMDA2NDQKPiAtLS0gYS9mcy94ZnMveGZzX2lvY3RsLmMKPiArKysgYi9mcy94ZnMveGZzX2lv
Y3RsLmMKPiBAQCAtMTg2NSw2ICsxODY1LDM1IEBAIHhmc19mc19lb2ZibG9ja3NfZnJvbV91c2Vy
KAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiDCoH0KPiDCoAo+ICtzdGF0aWMgaW50IHhm
c19pb2N0bF9nZXR1dWlkKAo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbW91bnTCoMKgwqDC
oMKgwqDCoMKgKm1wLAo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBmc3V1aWQgX191c2VywqDCoMKg
wqAqdWZzdXVpZCkKPiArewo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBmc3V1aWTCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZnN1dWlkOwo+ICvCoMKgwqDCoMKgwqDCoF9fdTjCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdXVpZFtVVUlEX1NJWkVdOwo+ICsKPiArwqDCoMKgwqDC
oMKgwqBpZiAoY29weV9mcm9tX3VzZXIoJmZzdXVpZCwgdWZzdXVpZCwgc2l6ZW9mKGZzdXVpZCkp
KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVGQVVMVDsKPiArCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKGZzdXVpZC5mc3VfbGVuID09IDApIHsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZnN1dWlkLmZzdV9sZW4gPSBVVUlEX1NJWkU7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChjb3B5X3RvX3VzZXIodWZzdXVpZCwgJmZzdXVpZCwK
PiBzaXplb2YoZnN1dWlkLmZzdV9sZW4pKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUZBVUxUOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoGlmIChmc3V1aWQuZnN1X2xlbiAhPSBVVUlEX1NJWkUgfHwgZnN1dWlkLmZzdV9m
bGFncyAhPSAwKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZB
TDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgc3Bpbl9sb2NrKCZtcC0+bV9zYl9sb2NrKTsKPiArwqDC
oMKgwqDCoMKgwqBtZW1jcHkodXVpZCwgJm1wLT5tX3NiLnNiX3V1aWQsIFVVSURfU0laRSk7Cj4g
K8KgwqDCoMKgwqDCoMKgc3Bpbl91bmxvY2soJm1wLT5tX3NiX2xvY2spOwo+ICsKPiArwqDCoMKg
wqDCoMKgwqBpZiAoY29weV90b191c2VyKCZ1ZnN1dWlkLT5mc3VfdXVpZFswXSwgdXVpZCwgVVVJ
RF9TSVpFKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FRkFVTFQ7
Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gK30KPiArCj4gwqAvKgo+IMKgICogVGhlc2Ug
bG9uZy11bnVzZWQgaW9jdGxzIHdlcmUgcmVtb3ZlZCBmcm9tIHRoZSBvZmZpY2lhbCBpb2N0bCBB
UEkKPiBpbiA1LjE3LAo+IMKgICogYnV0IHJldGFpbiB0aGVzZSBkZWZpbml0aW9ucyBzbyB0aGF0
IHdlIGNhbiBsb2cgd2FybmluZ3MgYWJvdXQKPiB0aGVtLgo+IEBAIC0yMTUzLDYgKzIxODIsOSBA
QCB4ZnNfZmlsZV9pb2N0bCgKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biBlcnJvcjsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gK8KgwqDCoMKgwqDCoMKgY2FzZSBG
U19JT0NfR0VURlNVVUlEOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
eGZzX2lvY3RsX2dldHV1aWQobXAsIGFyZyk7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBkZWZhdWx0
Ogo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTk9UVFk7Cj4gwqDC
oMKgwqDCoMKgwqDCoH0KCg==
