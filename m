Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6BD97F37
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 13:36:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82FDB8F8074
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 11:36:12 -0700 (PDT)
Message-ID: <516D9A0A.7060708@oracle.com>
Date: Wed, 17 Apr 2013 02:35:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't return 0 if generic_segment_checks() find
	nothing to write
References: <51682CCC.308@oracle.com> <20130416182624.GK22182@sgi.com>
In-Reply-To: <20130416182624.GK22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ben,

On 04/17/2013 02:26 AM, Ben Myers wrote:
> Hey Jeff,
> 
> On Fri, Apr 12, 2013 at 11:48:28PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> At xfs_file_aio_write(), we just return 0 which means a successfully operation if the ocount
>> is evaluated to 0 at generic_segment_checks().  Generally, it'll occurred if the specified
>> write count is 0 from the user space.  However, for example, if the given offset is over the
>> maximum file size limitation although nothing would be written into the file, in this case,
>> the underlying file system should detect this issue and return a proper errno instead.
>> Hence, the beginning pre-checking up against ocount would conceal some real cause and confuse
>> the user space program maybe.
>>
>> To fix it, we can delay the write count verification until xfs_file_aio_write_checks() is done.
> 
> Could you wrap these around 72 columns or so in the future?  Don't worry
> about reposting this one unless something technical comes up.
Sure, I'll take care of the patch format in the future.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
