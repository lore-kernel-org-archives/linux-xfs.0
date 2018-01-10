Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57340 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeAJT4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 14:56:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0AJplav076495
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:56:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fds41r4pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:56:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0AJkHMN006943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:46:18 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0AJkHps030539
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:46:17 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Parent pointer design bugs
Message-ID: <adf6f96f-fc4b-e2eb-a204-db8a39007fa7@oracle.com>
Date: Wed, 10 Jan 2018 12:46:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi all,

I've been working on a new xfstest for parent pointers, and discovered 
that parent pointers are not getting created for protofiles.  I'm
exploring the idea of adding the parent pointer in xfs_dir_createname 
(instead of xfs-create/xfs_link/xfs_rename).  But I think that means 
that I'd have to change xfs_dir_createname to take the new xfs_inode 
instead of just the xfs_ino_t.  Which I'm not sure is
going to work out in all cases where it is used.  Before I end up 
chasing it too long and changing the design too much, I wanted to get 
some feed back to see what folks thoughts were.  Thanks!

Allison Henderson
