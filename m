Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECFFF7CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 21:51:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 800F6AC004
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:51:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iiutNwnkvPofAqCy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 19:51:35 -0700 (PDT)
Message-ID: <51BA852F.4040706@oracle.com>
Date: Fri, 14 Jun 2013 10:51:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/8] xfs: log space validation
References: <5195C239.5010905@oracle.com> <20130614015928.GP29338@dastard>
In-Reply-To: <20130614015928.GP29338@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

On 06/14/2013 09:59 AM, Dave Chinner wrote:

> On Fri, May 17, 2013 at 01:38:01PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> This is version 2 of fix log space calculation if the log stripe unit is specified.
>>
>> I changed the subject in this round since there are many changes belong to the log
>> space reservation interface adjustment.
> 
> Hi Jeff, 
> 
> Given that I'm in the middle of reworking the kernel and userspace
> source structures, do you might if I pull this patchset into my tree
> for 3.11 and rework it to fit the modified structure I have now?
> I'll do the same with the userspace patch if you have no objections.

That sounded fine to me so that I can have more time for investigating
the possibility of performing quota check in parallel as well as the
compressed inode caching. :)

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
