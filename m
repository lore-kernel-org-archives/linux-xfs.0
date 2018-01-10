Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbeAJX6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 18:58:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0ANvJHS056353
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 23:58:14 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fdv65r4fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 23:58:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0ANwEcw025910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 23:58:14 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0ANwDEQ010877
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 23:58:14 GMT
Subject: Re: Parent pointer design bugs
References: <adf6f96f-fc4b-e2eb-a204-db8a39007fa7@oracle.com>
 <20180110225440.GV5602@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <da529817-04d5-086e-d9c1-37de7425d0a9@oracle.com>
Date: Wed, 10 Jan 2018 16:58:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180110225440.GV5602@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 01/10/2018 03:54 PM, Darrick J. Wong wrote:
> On Wed, Jan 10, 2018 at 12:46:16PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> I've been working on a new xfstest for parent pointers, and discovered
>> that parent pointers are not getting created for protofiles.
> 
> xfsprogs, IOWs.
> 
>> I'm exploring the idea of adding the parent pointer in
>> xfs_dir_createname (instead of xfs-create/xfs_link/xfs_rename).  But I
>> think that means that I'd have to change xfs_dir_createname to take
>> the new xfs_inode instead of just the xfs_ino_t.
> 
> Yes, you'd probably want to pass the inode to xfs_dir_createname (and I
> suppose xfs_dir_removename) if you decide to move the point at which you
> queue the pptr defer op into the _dir_ functions.
> 
> However, consider the repair case where we either (a) have a dir entry
> and no pptr or (b) have a pptr but no dir entry.  It's easy to repair
> the directory links in either scenario if directory updates and parent
> pointer updates are kept as separate libxfs calls.
> 
> There's also mkfs/proto.c which want to be able to create an arbitrary
> directory tree in exactly the same way as a regular creation would.  It
> seems to me that the orphanage management functions in repair/phase6.c
> are doing basically the same sort of things -- creating the lost+found
> directory, linking orphaned inodes into said lost+found directory,
> re-stuffing collected directory entries into a directory, etc.  Perhaps
> it makes more sense to hoist some of the fs/xfs/xfs_inode.c functions
> into libxfs, add the pptr calls to those functions, port that to
> xfsprogs, and then refactor mkfs/repair to use the new libxfs functions?
> 
> FWIW xfs_inode.c is already ~3600 lines long and contains routines for
> handling inodes and for various directory manipulations involving
> inodes, so I think it's fine to break that file up.
> 
>> Which I'm not sure is going to work out in all cases where it is used.
>> Before I end up chasing it too long and changing the design too much,
>> I wanted to get some feed back to see what folks thoughts were.
>> Thanks!
> 
> tldr: I'm leaning towards refactor and port some of the xfs_inode
> routines to xfsprogs... :)
> 

Alrighty, I'll see what I can work out.  Thank you!!

> --D
> 
>>
>> Allison Henderson
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=9lB1PDKzm2gfSE5y-lOY3Vh-lrKgdXAOkR4V96QBhB0&s=qvbtvoxhw2nHvyF_z-kqLeLED9hGVZb1cp_alEA5rNI&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=9lB1PDKzm2gfSE5y-lOY3Vh-lrKgdXAOkR4V96QBhB0&s=qvbtvoxhw2nHvyF_z-kqLeLED9hGVZb1cp_alEA5rNI&e=
> 
