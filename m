Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313F0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 09:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiBVJZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 04:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiBVJZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 04:25:42 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20129.outbound.protection.outlook.com [40.107.2.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF67149958
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 01:25:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2qeSxyoFtMsltMefjejb3AxbLrMlXH4Hgi0exsI/I9oGd0qhsJQOgM9aC43poElSnuljf2DL1GhGwIHyfzhuBo+zwSSBh5W53WwiLINZFLnvp5AYsQG4b0+UcYnrloKHNqB6gACdLbO3k7qVGI9nY61OveJVYbdP6ZcLnYRQ6uytQhcup8qhgr8GH5ou83OPKyzd7rs9feQnblqE+mbF3OkFK8TtJ1L0uNAM6ZlV7lJb1MMyAnc0vq3bjEwux1E1Z5OFehxC/zaEOffmI0WblRTQ88NHkQOdmFvkRNaAqTkx7rLfbyBoBvZBBqrArsA1uFRJpsIu39A3vZkqhpVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rff+XlPKrcTGmWnn4FQJNemyvq92UmrdlS0D/Y4xZ/0=;
 b=aiv2lU299FeRvtlVtGJlMEZt1MFTJM45BwP8nOm1O1J1gIo7HLG3VYWtG2iopegNZxKoDyXAjKhLusPwH7xo+umAs5Xe167ormmsdJsxIlcUjzeWK5EqxSdr3TmtLnqPPlRlLocZ+7Sne6LSr/YUUOmGnqpSaPtdm6Oo0PSgTf/oZ+ack57qJv3AmezCIqhobGgCgkCnOMvs5hBv5vwUVPuCl/R89mo7roY4Q8F2cYhUg/5DAWMRV14uV4WUF5NaX4NY48QonrdzdI2U0rV91nHTZPxTBj5CjwWlwxhRSjWMfjJEmXOfvetakYPjUghAUIZvMaiB3NALh5hauy3f/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rff+XlPKrcTGmWnn4FQJNemyvq92UmrdlS0D/Y4xZ/0=;
 b=SX4aazWd/pCE3C1lrJYsQs9Z83hsvm5Wjjde6YCyIvpOAuAHOv5emUjrJGnBf1ury5yXNYbwFymXQUldtFv6hPPAyrd0pZ0sc2Hjba2r0jJKAalIHOig8rt3d9K9XV/onOHb+mqzI317pJgwcHtEOW3VdCNU3l5KvVDmzOGbsQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AM0PR08MB5441.eurprd08.prod.outlook.com (2603:10a6:208:17d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 09:25:14 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::6934:1cfe:5b49:dec2%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 09:25:14 +0000
Message-ID: <f21fab4b-1056-b092-25fb-29e1fba4aa21@virtuozzo.com>
Date:   Tue, 22 Feb 2022 12:25:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, christian.brauner@ubuntu.com,
        djwong@kernel.org
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220222083340.GA5899@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR03CA0019.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::29) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116c6c38-a5ea-4a23-4e10-08d9f5e53b4d
X-MS-TrafficTypeDiagnostic: AM0PR08MB5441:EE_
X-Microsoft-Antispam-PRVS: <AM0PR08MB54414E381604AE7083A52CEBE13B9@AM0PR08MB5441.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVQiZIZaYQTmL5+gDv/vhXSyKQiAMLlD3qltHVdbtvW1kb6FPZHKjJKBF6V2dTGDLnRtIcCoj8iyptTKvkhpXscn7eKjBdlbBwf0vkgc3ujOPbJdfBvu2BXGbQkWJanZIATL5+Yt1MCGKTE09bjJ4zzsZy47baq+tiw+OUTyGUZc5G8v4dC3o3irKUJjdxJRoIr75phNcoLYrwAUKmDvoKOhHVSG97UDcTxSdUWnPWH0SSWm3AbbGCGw8ZPqspWuoFhB7W3bcD0q0f0JrNUwN4fEsblWgwpZXegbDqzyfLx+RIOcuBOLp9qhREba4dgHlZTTRAq1ug3urTsL3QqrajW/4I1tMYIaffkCae/FlwaQ4BHfU5YzxamHU7EhmBDoO90VRLH3ReXXPfkKR0GbOH1X5IRL0WoMzT0aDghhY6450I48jddTtt9ukp3PGKZXVeN0fi3NmW3hWYVrGj6MLxGDpWVRS+nyKD+57SZVuEnhiO1gI0AzJWQeRAdb319bkSgW2Fwslq9+ia7ouFkE5+EHXsjTlb+Rlg2SdtsPU72RgCTEAKv/ie4T7vWK7Aqc8kijw5XMLLRwU100eFaM1jw9MDkrhtWEqRHRlYjO7baCcBA/1WkikNKIxRKHSO3aYFzVX9dq7iqrVSKWFvhELpZj4s42awOS61YWd4L11MUsYFYAUwf14sUhNozm8rsTH9LHj05Ap8CRObFmyr1XSCK/GMmLkcCREMy5KWsJrnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(508600001)(6512007)(6486002)(31696002)(4744005)(44832011)(86362001)(6916009)(316002)(5660300002)(2616005)(2906002)(4326008)(8676002)(31686004)(38100700002)(186003)(6506007)(66556008)(6666004)(26005)(36756003)(66946007)(53546011)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Szg0eUQ2Sm4zT3hiTGE0K044WnNXN25UUkZ1V2paY3ZMZks4VTZXcUh1dUtr?=
 =?utf-8?B?dU9mS3hOYkNtbjZxYUxkWVpEeGlTZFBGVytFTTRIcmVVNmJUekRPZ2RKTlJ1?=
 =?utf-8?B?QS9pMkpvcm5WN0k0Tm5DTTVremlmRU8zRk9lTSs0YXhxSnE2dlU0L1M0NGQw?=
 =?utf-8?B?MnBSN1JjcTFRMElaYkFGMzl5bDJBclBVUDh5NzZWSXhrazhldzRoTEw3bUs2?=
 =?utf-8?B?bUxvNGhGK1M0L25nbVNoZjRGd1Y4WVlmUzdKY05jNmdHZFJoL24xb2djWVlI?=
 =?utf-8?B?SS9LNW5CZ1ZqWS93Um5udWpqN3VwbHBQTy9peVBzbXgxbzdWQU9vOWhvUC90?=
 =?utf-8?B?Q25EdDk5RWRkV3pYZkgxY3huRWxwQ2VjR00yRzNNOTVrK2c5L1N1RkdXY0hE?=
 =?utf-8?B?TWVJbFpsZXpvWWtNMytNNDAvWWJZSDlxWlpOc01BT0Jlb1ZLRHdXdUhJSGdE?=
 =?utf-8?B?VDZaTDM5YXdLWkZlZ2M1RmRKT3REcmRHNiswUzFDUmVhMTFDT1NGSUlaV2M1?=
 =?utf-8?B?WnpBd3dDOGVPVTBYV0xoNmlVd0NxVHFYdjYvSXFDZTNTNjgrYWxqOU5GNzFK?=
 =?utf-8?B?MWw1WXJsdE52azFQeHJpYWV5WHBTYkhtUkJQeW1SQk9iV0R4NzRUa3FCL2pS?=
 =?utf-8?B?aXRqbEo2QWUxSmlIVUwxMmJTL2pJMEpTTHpIanEvSFVkVkVoQ1ZOeFlNNTdp?=
 =?utf-8?B?R09oelJUN25YRUp6ZE1zTW5Jd0NvUG50SmZFQXFDYUExSTVDcmtHQ0FjeWtn?=
 =?utf-8?B?S1ViZVNVUWNpSVJSYnlDR08xT3d2dTJJTmE5N1dTS2NvZVFIWEtkaUc4SHhY?=
 =?utf-8?B?THA1dmg2Y2JPd3JoVnZTaTBqam14TEk1Zk82c2paMkxGTnB4S0VzdzdKcnV5?=
 =?utf-8?B?T056YTI4TklqYTVDN2tQdVR5cWJkWlF1SXNkT21vam8wYnBxNWJ2dE0wcVBk?=
 =?utf-8?B?Z3RMZ2dSRTZDWG1UcHEySUtSbFNUeGhQMWh5dS9JMnphSm5HbGhYTWhMNTNk?=
 =?utf-8?B?YnorVHQrcXVPdlZsbnhVeWV4OHRTcVc0NmVnUkt2UktjcmNxQUE2OHc1dTl5?=
 =?utf-8?B?MEpRWXQ4VzUwTTQxcWdEbzdSV3M0YVZaOTUxSFJtSFVONzExb1M5eXIxdXox?=
 =?utf-8?B?YnZDL09CRm5pNXdFZ3hpbEhnUjc1UnVsS1k1WmtUdStGdDhWVk0xdVY2bHNv?=
 =?utf-8?B?NldVZ2ltZ1JXT0JrOTZaQk5PbTNNMnBvNDc5TGl6UHF2UExsTjNuWmp5OG5a?=
 =?utf-8?B?MFlDMzhqVU5zMWVtaHpHT3FhdHplVlhuZU9aMXhqd3dEYW12Y0NBRkNBL2RF?=
 =?utf-8?B?ajhRdWpWaUxXa0QzakU1UUlKckkzT2ZPM0dOMktqVlFrekMxSFg4Y2VmTm1D?=
 =?utf-8?B?NTF6SFpTTXBxeVNhN3ZPNmlpU3Fsa2JKamlFMnNvcU1yVE04R3JXUVRxdUJl?=
 =?utf-8?B?Vi8vTlNOYUdRZFhOTWlJUDliaitrQmNTN2RVb0ZsQndlU0JVeXFHOGFIZmcw?=
 =?utf-8?B?V3JESkFHeG5CYWFnOTF6ZG5QQ0F0MzBiZGtpNzMrSXZ1N3Rrd3RRb1hrV1p6?=
 =?utf-8?B?VTBCM2E5WEVGa3Z1dEVITnozS2ZpTHBueEpQQVpoMHJCN0xmbm9VTDEzaWYz?=
 =?utf-8?B?SDhZaXhVNnlQdFo0M1prbk9aZWFqRmNJTWh1eXc3bCtycjkrU0pPb1JsM2Zw?=
 =?utf-8?B?Zkg3WFpmTWZSRE00TkdHOWwyK0ZsU2g2TXRzYzVXM3RTcmk0N2tzbzhWeHFV?=
 =?utf-8?B?cWtVV3ZyZzViaXZDK2lIeFlkNVpOQXRBVXdNc3dSUCtWdXdZUW00aXJtem9X?=
 =?utf-8?B?bmdWZCsweFkzektzZkpBY0tZZ1FkVHIycEZ0WlVnR25vZyt3cWZlN3JlL2pk?=
 =?utf-8?B?aVMwRnIzQk9FVmI4V3JES1cwRi9BS2N1TnpFYnkyYXAreTQzdytGNzl6dWht?=
 =?utf-8?B?YUlKaWZxVFBxNVFQNGFFSUZjRXVVVU9TZ28rUGh2OXpmbUxZTnltY25tVHFH?=
 =?utf-8?B?c3l3Tko2YVJ2YmxsaTlXVkU5MldFUk1yRW9RRUdZL2djRWZjMUlidlJxS3ND?=
 =?utf-8?B?NzBkOWRodW85NnB2eDVBM2JKYyt6TFBSUUkxdjMyZVpaQmlDT2ZGY25wVHlM?=
 =?utf-8?B?V0tZc3RaRy9TWG9wV0hxRjF0R1VEbkMzTXU5dVAxakh6R2VvclduN2Y2aDFE?=
 =?utf-8?B?Z24zdmpCQzkyTlJCdFFQTGJ3R0JueURNNVJQSlVDQ0ZtVEd3d1cwRXQ3Qldj?=
 =?utf-8?B?SThqZzdTcm5ONHRCSkZYQ0dHVWVBPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116c6c38-a5ea-4a23-4e10-08d9f5e53b4d
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 09:25:14.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqCW95GNz03QDqkiSxGxL5KXuhq2MOLTUD4sqlROHey6s/omNmN92oIX+cazOLck5G5domRQVFZaWMTkyfs63X/gPFExKP+S9Ou5J0H+qCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5441
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2/22/22 11:33, Christoph Hellwig wrote:
> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
>> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
>> bits.
>> Unfortunately chown syscall results in different callstask:
>> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
>> has CAP_FSETID capable in init_user_ns rather than mntns userns.
> 
> Can you add an xfstests the exercises this path?

Will do

> 
> The fix itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
