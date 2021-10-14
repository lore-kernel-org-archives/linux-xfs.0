Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C43C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 10:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11AF36101E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 10:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJNKKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 06:10:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22392 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhJNKKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 06:10:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19E90UK6029661;
        Thu, 14 Oct 2021 10:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=veVCoP+Nq7EZU8vVYqVuEJa7WfIhM5ns9kLUFpZRfbA=;
 b=OM5hkPA00YQUBEZ9fnHKxPf/+3E/rznTrTDt1rVNJ/qWC5vWbi3w0FfQ3RTVrJ5kqS6h
 rp6njVzqbhfDodIRDbIL+nrwXMFhNQNnH8+2NN1n67UpbL06a2MujECZNv4BtlW3y968
 0FEbaqqh8uWDBbF+j6Ab0GVv4mw3OJImdtMGJT5YMhvjiBMkU0M38/KertCVTx4h+w4J
 0gRYtTxVS0ocJnzB0tSHIioa+3lJ5Js21rv/DZ+AgNvt2IjmEAZ9foru4SgEg8Hztdfa
 o5pI0uvrDHjLpyXIpnBJvPxIl0xIipwHm5147UhitS08JPvuExMpQ49V0swCl45pr+9K Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bphhu8anf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 10:08:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19EA5DY3058738;
        Thu, 14 Oct 2021 10:08:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3bkyvcdfrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 10:08:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os8NGS6SCXX0Fcpbg68oTh4x4Oj0vEcfbeSrEFxB6eJ3WjPwGDR2Cb6Ra2bGtukUmk69hDBt6oc0PigJMD2U6N3zrBPC4i1LNX+qNTHjTfSZO0Or/Wgi+eT2xAGGOIGo1i8+qOoau+fJrcZMWVO58ro0DQcpgkygoGKOQad5g7BLzIV2CIr7aviwjwEQVe2PKOXneUBK9t1Wkpe4F6Bp1yQCsRKrUhxf5DVKJg0VS9JtuU992cAUnK0rhUnpgWwV8Qqw7V/jn+QmJTJglZJI5M1BEYW8C24uTxStQXuQbEjverX4rvYaAA3uL7RFvPS0iB22eJCS0wNTqRzWFKu2gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veVCoP+Nq7EZU8vVYqVuEJa7WfIhM5ns9kLUFpZRfbA=;
 b=ew0oVmhrO8MDkOncPKw8Ih1JuDmOMpykr00nues+oQoa6j6P++Se1wUiTXeyAApfa3adQFdluDmShRedaypdKl2xwd6rzYcO2qcRzXj6kvzKjagEwbAZEI7tWaLShm8ibuieVhvn53iq00RxMMwoPV0z8BVlWr+jIqQ+v+U7SbWSLjikWkkkGSk76WcN2Rj4gK63GaskopddKUxcD0K6+TcDSCxrVoTtnmklCoQoGR2MQKtTHPuN5Wf7WiJp5ahvQ+lsFlOu4DBKyEcSoUAHycFbLCGSm1OnVnUd5UxBHqTJX+mWX0fy0QUPZ2vN3Lf1lM6lkhqrjO6PMoIBQnyX0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veVCoP+Nq7EZU8vVYqVuEJa7WfIhM5ns9kLUFpZRfbA=;
 b=trTE0PKqcz2pFE3kALmerSoG9gYG6GShp2BK52bAtFEug2hRROEj1rFP28S5hpiKjsqg6AogbFAWLEB1Cl64abmctqnhg+cSynIwsaYAQY55ZD7gCHORkxSVXs/Hj3VBGFxKQ5gfmJl+n+NfsLX0gIN0e+NBmwKoxHdtZ6i1sAo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2608.namprd10.prod.outlook.com (2603:10b6:805:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 10:08:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 10:08:02 +0000
References: <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
 <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20211010214907.GK54211@dread.disaster.area>
 <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20211014020032.GM2361455@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <20211014020032.GM2361455@dread.disaster.area>
Message-ID: <87sfx3537z.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 14 Oct 2021 15:37:45 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:3:18::24) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by SG2PR02CA0036.apcprd02.prod.outlook.com (2603:1096:3:18::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 14 Oct 2021 10:07:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 852791fb-4f19-4d3c-0a1d-08d98efa8160
X-MS-TrafficTypeDiagnostic: SN6PR10MB2608:
X-Microsoft-Antispam-PRVS: <SN6PR10MB260887337F049A26EB3EFBC0F6B89@SN6PR10MB2608.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOY7SfvyDYxsaYkfcZLdT9frzeuyN0T9lbSQK5HxVkTRqxC/ZPW035z8SrFLFjoodnPgE1kuflerdanxYi9tlqF1s844EbbHOVsCt7+qyXI0b1uIHYfa+J70z/H6Ub8A/cDd2PztbB+4f2HPxNJb1NXP3NMkMEf/D+WKPjvGMMnWGeS3G2E5AcVq6oqoNRaLIpZQ12pXgzTHdsiRiQG7ifsb0iNUT/9Ouezbe3BKABv4mnfLECVsc0wl8K+tpnRkIcG5eL/aMe/S4XCHxHaQD1ADvJxI6HwKhc362PjcBufDP3mMqUuqFiJfQ7A5moDY3hNtMgwRYUgvJdBcSsk7IqwuWOEPsvGEEH1WOuMfvmanwwGZtSacIcYVh1e/mdRSW4cA/LrsrIrX4AWu2V5e5u2pdI8DkrJ/kOc8ppRQT0heubrcd/rlBBrpaFbW5TO6cdeEPPsfp8ugkv7svFN1BL+ov9f2ppcN+EBM9HNJVlRQQJ+htAOWZHCRiohZNofpO1bQjJp+mR9XWJZrZH8bYSrgxTshUz1LQVD88hl88cwhpLvTREGnyHfSsJTLPs3PCVAaNzE/vhrrNQ9SmyNJR75zvc5KamWC97iuvrWBIarVm1TnQL8r4ERBDha6KBTs5aFBephtB2gPBAhPvuP1qr9lT2TXOv0L5Sd7x/shPd18cck8WHGk6Kq2uSt6lTah6IQFbIMabB1pXymMyFAbGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(53546011)(4326008)(26005)(66556008)(956004)(508600001)(5660300002)(6666004)(83380400001)(86362001)(33716001)(38100700002)(316002)(6486002)(30864003)(6496006)(6916009)(8936002)(186003)(66946007)(8676002)(52116002)(2906002)(66476007)(38350700002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9XD0Xnet3alS4laF4XiK+p3etqHCXsQawvPTxuZBQ9C22eh07li2D9Jpe03?=
 =?us-ascii?Q?G1xJhhFKajqSNToz4XSSr8lTFRDpMkN2xcGjfFf4dc/bExywm2Q0vujzdmMU?=
 =?us-ascii?Q?I+yXhfobBIXScSSjq9MvDYc6G2ttAvRg56f1VGf5KSXFIvzCYFemas+AihG0?=
 =?us-ascii?Q?Z3iApgiH8mk8ASleW07E/E9cuEoUcAzJxlWmkYVQtz1szBmP1AmdpS4fbZo8?=
 =?us-ascii?Q?n5XAU4daUbhuZDEzLJRmu0oMM0HfFJ1rVhoAXChZe4XtDWQ4RTvpOjjzsfH8?=
 =?us-ascii?Q?CfKQ50qmxxD+3bURsfzmwXt9ZVwGZignz0/RKmptKzM2nWnS3dSm2eznj73S?=
 =?us-ascii?Q?8rT8ErOjTdTW2yGQ6Z/kgzog2Rv0OAiNs5hkyjbmuwF+yTaUAHzrQIZqL5Kw?=
 =?us-ascii?Q?hzinvThVIL02OUrnVdug/BoS21Ft+W6turvTToUtWjPuicqnn8bWgtR6OsrE?=
 =?us-ascii?Q?LHx7v0MGqlu0fA1CUI4TXUC8SshS8ZodA9WEeIA8V5YoProg+ciN/WAQ3qqr?=
 =?us-ascii?Q?eIq8jKCu6MYx9okMXZ6Sx8nbt0d6wGj9PcbZqgrZMqhThh0visugMIKtfc/W?=
 =?us-ascii?Q?unbwZWznFw3ZrO0bMVui4JfhnSWZhigyr1WtvajyzOdnC6zHn1jTeD+tnTBx?=
 =?us-ascii?Q?IoMBj5gznVVAXWTaa7tw5P2qE0nVjHJhKEx8fJUgX/vMNGtnMuu8wfhzABcS?=
 =?us-ascii?Q?Obiv3jkr7HgvBRAYpQG3/2bbToaT7rk9oYvpz6gNXoD/1c24RVM5Q7iSQJa6?=
 =?us-ascii?Q?qMzQPgmGSXpgX4Af3bU6gFVUVvpmXfPAYsBJMBp78Z/eZE0tIXE9MkJHDy7j?=
 =?us-ascii?Q?m1AAw+nSOfuKPc64u353aw8j5TTpzmWX5jxhwcGxnMDtUx6Bi+WqEIXyxy8H?=
 =?us-ascii?Q?V31Guky7ThKveRKApc6looCWsMJVSFDZuu/FM/YHuCGXPN61YRoLZZwrRJbL?=
 =?us-ascii?Q?JHBhD8Nswgb5xkOO8BomwoIaelmzsnHwM+GtmucyulK80nqI5ggUX0OWQ2l8?=
 =?us-ascii?Q?P4iKmd6fLtCpuSVTDRBNqw493ar2M4NGCRSZehOHQ1oog1vpJmUUWzSRkrHK?=
 =?us-ascii?Q?IBrZRYQYIX1AZ3zbj/+ynXvjLGhy7+qANP0elFYUO+Tcb4r9QWdfoDdpW4dE?=
 =?us-ascii?Q?SBPrl0qpNt2UpZC5XbQcy5MljcnvTAbK8hGuWGMqs3F6axvoCZFyo4U7/qqo?=
 =?us-ascii?Q?dVKOitgnC9EWyU6rycSlzWkIdYOpeSi4vWMcgIeXK09Flyod9tYrXPEzrfGR?=
 =?us-ascii?Q?OkphiUrPk/CIBNlX+i/7cGG2YcwtMZAQC74/dDrt9J1RMZaL5BlND9O347E+?=
 =?us-ascii?Q?NEvyaNwBDd82uYDg3ltfqRPB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852791fb-4f19-4d3c-0a1d-08d98efa8160
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 10:08:02.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9SNFjgKrb+UILVcR5wEat7OLoqtoXD1cX77OzamAV+H5RpyuAviAKSHKW+9xSRkpiLa1P/0NPwvKufIrPXN7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2608
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110140062
X-Proofpoint-ORIG-GUID: 3ezkdq-jYy-kQwIK-SPcXfXyyK6Evf3t
X-Proofpoint-GUID: 3ezkdq-jYy-kQwIK-SPcXfXyyK6Evf3t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 14 Oct 2021 at 07:30, Dave Chinner wrote:
> On Wed, Oct 13, 2021 at 08:14:01PM +0530, Chandan Babu R wrote:
>> On 11 Oct 2021 at 03:19, Dave Chinner wrote:
>> > On Thu, Oct 07, 2021 at 04:22:25PM +0530, Chandan Babu R wrote:
>> >> On 01 Oct 2021 at 04:25, Dave Chinner wrote:
>> >> > On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
>> >> >> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
>> >> >> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
>> >> >> >
>> >> >> 
>> >> >> Ok. The above solution looks logically correct. I haven't been able to come up
>> >> >> with a scenario where the solution wouldn't work. I will implement it and see
>> >> >> if anything breaks.
>> >> >
>> >> > I think I can poke one hole in it - I missed the fact that if we
>> >> > upgrade and inode read time, and then we modify the inode without
>> >> > modifying the inode core (can we even do that - metadata mods should
>> >> > at least change timestamps right?) then we don't log the format
>> >> > change or the NREXT64 inode flag change and they only appear in the
>> >> > on-disk inode at writeback.
>> >> >
>> >> > Log recovery needs to be checked for correct behaviour here. I think
>> >> > that if the inode is in NREXT64 format when read in and the log
>> >> > inode core is not, then the on disk LSN must be more recent than
>> >> > what is being recovered from the log and should be skipped. If
>> >> > NREXT64 is present in the log inode, then we logged the core
>> >> > properly and we just don't care what format is on disk because we
>> >> > replay it into NREXT64 format and write that back.
>> >> 
>> >> xfs_inode_item_format() logs the inode core regardless of whether
>> >> XFS_ILOG_CORE flag is set in xfs_inode_log_item->ili_fields. Hence, setting
>> >> the NREXT64 bit in xfs_dinode->di_flags2 just after reading an inode from disk
>> >> should not result in a scenario where the corresponding
>> >> xfs_log_dinode->di_flags2 will not have NREXT64 bit set.
>> >
>> > Except that log recovery might be replaying lots of indoe changes
>> > such as:
>> >
>> > log inode
>> > commit A
>> > log inode
>> > commit B
>> > log inode
>> > set NREXT64
>> > commit C
>> > writeback inode
>> > <crash before log tail moves>
>> >
>> > Recovery will then replay commit A, B and C, in which case we *must
>> > not recover the log inode* in commit A or B because the LSN in the
>> > on-disk inode points at commit C. Hence replaying A or B will result
>> > in the on-disk inode going backwards in time and hence resulting in
>> > an inconsistent state on disk until commit C is recovered.
>> >
>> >> i.e. there is no need to compare LSNs of the checkpoint
>> >> transaction being replayed and that of the disk inode.
>> >
>> > Inncorrect: we -always- have to do this, regardless of the change
>> > being made.
>> >
>> >> If log recovery comes across a log inode with NREXT64 bit set in its di_flags2
>> >> field, then we can safely conclude that the ondisk inode has to be updated to
>> >> reflect this change
>> >
>> > We can't assume that. This makes an assumption that NREXT64 is
>> > only ever a one-way transition. There's nothing in the disk format that
>> > prevents us from -removing- NREXT64 for inodes that don't need large
>> > extent counts.
>> >
>> > Yes, the -current implementation- does not allow going back to small
>> > extent counts, but the on-disk format design still needs to allow
>> > for such things to be done as we may need such functionality and
>> > flexibility in the on-disk format in the future.
>> >
>> > Hence we have to ensure that log recovery handles both set and reset
>> > transistions from the start. If we don't ensure that log recovery
>> > handles reset conditions when we first add the feature bit, then
>> > we are going to have to add a log incompat or another feature bit
>> > to stop older kernels from trying to recover reset operations.
>> >
>> 
>> Ok. I had never considered the possibility of transitioning an inode back into
>> 32-bit data fork extent count format. With this new requirement, I now
>> understand the reasoning behind comparing ondisk inode's LSN and checkpoint
>> transaction's LSN.
>> 
>> As you have mentioned earlier, comparing LSNs is required not only for the
>> change introduced in this patch, but also for any other change in value of any
>> of the inode's fields. Without such a comparison, the inode can temporarily
>> end up being in an inconsistent state during log replay.
>> 
>> To that end, The following code snippet from xlog_recover_inode_commit_pass2()
>> skips playing back xfs_log_dinode entries when ondisk inode's LSN is greater
>> than checkpoint transaction's LSN,
>> 
>>         if (dip->di_version >= 3) {
>>                 xfs_lsn_t       lsn = be64_to_cpu(dip->di_lsn);
>> 
>>                 if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
>>                         trace_xfs_log_recover_inode_skip(log, in_f);
>>                         error = 0;
>>                         goto out_owner_change;
>>                 }
>>         }
>> 
>> 
>> However, if the commits in the sequence below belong to three different
>> checkpoint transactions having the same LSN,
>> 
>> log inode
>> commit A
>> log inode
>> commit B
>> set NREXT64
>> log inode
>> commit C
>> writeback inode
>> <crash before log tail moves>
>> 
>> Then the above code snippet won't prevent an inode from becoming temporarily
>> inconsistent due to commits A and B being replayed.
>
> Ah, this is a very special corner case.  You snipped out the most
> important part of the comment above that code:
>
> 	/*
>          * If the inode has an LSN in it, recover the inode only if the on-disk
>          * inode's LSN is older than the lsn of the transaction we are
>          * replaying. We can have multiple checkpoints with the same start LSN,
>          * so the current LSN being equal to the on-disk LSN doesn't necessarily
>          * mean that the on-disk inode is more recent than the change being
>          * replayed.
> ....
>
> This is exactly the situation you are asking about here - what
> happens in recovery when the LSNs are the same and there are
> multiple checkpoints with the same LSN.
>
> The first thing to understand here is "how do we get checkpoints
> with the same LSN" and then understand what it implies.
>
> We get checkpoints with the same start/commit LSNs when multiple
> checkpoints are written in the same iclog. The start/commit LSNs are
> determined by the LSN of the iclog they are written in, and hence if
> they are the same they were written to the journal in a single
> "atomic" IO.
>
> I say "atomic" because it's not an atomic IO at the hardware level.
> It's atomic in that the entire iclog is protected by a CRC and hence
> if the CRC check for the iclog passes at recovery, then the iclog write has been
> recovered intact. If the write was torn, misdirected
> or some other physical media failure occurred, then we don't
> recovery the iclog at all. IOWs, none of the changes in the iclog
> are recovered. IOWs, we have atomic "all or nothing" iclog recovery
> semantics.
>
> Next, the fact that the inode has been written back and is up to
> date on disk means that the iclog is entirely on stable storage.
> The inode isn't unpinned until the flush/FUA associtate with the
> iclog was completed, which happens before the iclog IO is completed
> and the callbacks to unpin the inode are run. Hence ordering tells
> us the entire iclog is on disk and should be recovered.
>
> What this really means is that we cannot possibly see the
> intermediate commit A or commit B states on disk at runtime or
> before recovery is run. The metadata is not unpinned until the iclog
> that also contains commit C is written to the journal. Hence from
> the POV of the on-disk inode, we go from the original version to
> commit C in one step and we never, ever see A or B as intermediate
> states. IOWs, the iclog contents defines old -> C as an atomic
> on-disk modification, even though the contents are spread across
> multiple checkpoints.[1]
>
> Hence in this specific case, we have 3 individual modifications to
> the inode and it's related metadata sitting in the journal waiting
> for log recovery to replay them as an atomic unit. They will all get
> recovered, and each change that is replayed will be internally
> consistent. Therefore, after replaying commit A, the inode and it's
> metadata will be reverted to whatever was in that commit and it will
> be consistent in that context. Then replay of commit B and commit C
> bring it back up to being up to date on disk and providing the step
> change from old -> C as the runtime code would have also done.
>
> Hence at the end of replay, the inode and all it's related metadata
> will be consistent with commit C and so so this special transient
> corner case should resolve itself correctly (at least, as far as my
> poor dumb brain can reason about it being correct).
>

Thanks for the detailed explaination. I had figured out that multiple
checkpoints can end up having the same LSN because they were written to the
same iclog. The value of cil->xc_push_commit_stable is one of the things that
determine if the iclog is supposed to be flushed or not just after writing the
contents of a CIL context into it.

However the "atomic replay" behaviour had not occured to me.

>> To handle this, we should
>> probably go with the additional rule of "Replay log inode if both the log
>> inode and the ondisk inode have the same value for NREXT64 bit".
>
> No, we do not want case specific logic in recovery code like this
> because inode core updates are simply overwrites. As long as the
> overwrites are all replayed from A to C, we end up with the correct
> result of an "atomic" step change from old to C on disk...
>

W.r.t processing per-inode NREXT64 bit status during log recovery, I think we
can depend on the LSN comparison that is already implemented in
xlog_recover_inode_commit_pass2() to skip checkpoint transactions (with
different LSNs) which can make an ondisk inode enter an inconsistent state.


> Cheers,
>
> Dave.
>
> [1] There's more really subtle, complex details around start LSN vs
> commit LSN ordering with AIL, iclog and recovery LSNs and how to
> treat same start/different commit LSNs, different start/same commit
> LSNs, etc, but that's way beyond the scope of what is needed to be
> understood here. These play into why we replay all the changes at
> the same LSN as per above rather than skip them. Commit 32baa63d82ee
> ("xfs: logging the on disk inode LSN can make it go backwards")
> might give you some more insight into the complexities here.

Thanks for the commit ID. I will add this to my list of items to read.

-- 
chandan
