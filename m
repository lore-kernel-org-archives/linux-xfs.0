Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A36E67F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 18:01:19 -0500 (CDT)
Message-ID: <516740B8.4030704@sgi.com>
Date: Thu, 11 Apr 2013 18:01:12 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: Deprecating xfs_check
References: <1365716708.3762.32154.camel@chandra-dt.ibm.com>
	<20130411221754.GI22182@sgi.com>
In-Reply-To: <20130411221754.GI22182@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Chandra Seetharaman <sekharan@us.ibm.com>, Ben Myers <bpm@sgi.com>

On 04/11/2013 05:17 PM, Ben Myers wrote:
> Hey Chandra,
>
> On Thu, Apr 11, 2013 at 04:45:08PM -0500, Chandra Seetharaman wrote:
>> Hello All,
>>
>> Alex Elder mentioned about deprecating xfs_check, and he suggested is to
>> replace xfs_check command with a script, that says xfs_check is
>> deprecated, use "xfs_repair -n".
>>
>> Sounds ok ?
>>
>> Let me know if it is not the right approach.
> That sounds ok to me.  You might also consider making xfs_check a hardlink to
> xfs_repair and varying the behavior based on program name.  Then xfs_check ==
> xfs_repair -n.
>
> Regards,
> 	Ben
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Does "xfs_repair -n" need to provide all of the functionality that xfs_check
provides before it is replaced?

xfs_check can be run on a filesystem mounted read-only.  xfs_repair -n 
can not.

xfs_check has two options:
     -i ino   Specifies  verbose  behavior  for  the specified inode ino.
     -b bno   Specifies  verbose behavior for the specific filesystem 
block at bno.
which are not available with xfs_repair.

-Troy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
