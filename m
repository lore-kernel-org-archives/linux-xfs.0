Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752909AbdLMOEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 09:04:33 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBDE4K5Z104507
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 09:04:32 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2eu5k5g94m-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 09:04:32 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Wed, 13 Dec 2017 14:04:29 -0000
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Wed, 13 Dec 2017 09:04:25 -0500
In-Reply-To: <20171213025928.GZ5858@dastard>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
         <20171212142615.GA25327@infradead.org>
         <1513089296.3476.52.camel@linux.vnet.ibm.com>
         <20171212143647.GA10887@infradead.org>
         <1513091096.3476.66.camel@linux.vnet.ibm.com>
         <20171212233031.GX5858@dastard>
         <1513122931.3476.97.camel@linux.vnet.ibm.com>
         <20171213001342.GY5858@dastard>
         <1513128072.3476.121.camel@linux.vnet.ibm.com>
         <20171213025928.GZ5858@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1513173865.7839.3.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, 2017-12-13 at 13:59 +1100, Dave Chinner wrote:

> IOWs, if you need to identify a filesystem *type*, using internal
> magic numbers is not the way to do it. selinux, for example, checks
> sb->s_type->name quite a lot....

Thanks, this works fine.  Is there a defined max name length?

Mimi

