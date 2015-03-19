Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECE957F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 09:58:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD59F8F8068
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 07:58:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AGTMe0UmGl4uDs6x for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 07:58:27 -0700 (PDT)
Message-ID: <550AE412.7030805@sandeen.net>
Date: Thu, 19 Mar 2015 09:58:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
	<550AE35D.40006@sandeen.net>
In-Reply-To: <550AE35D.40006@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/19/15 9:55 AM, Eric Sandeen wrote:
> On 3/18/15 6:22 PM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> It's time to change the mkfs defaults to enable CRCs for all new
>> filesystems. While there, also enable the free inode btree by
>> default, too, as that functioanlity has also had long enough to make
> 
> "functionality" ;)
> 
>> it into distro kernels, too.
> 
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Forgot to add; needs manpage updates as well:

"By default, mkfs.xfs will not enable metadata CRCs."
"By default, mkfs.xfs will not create free inode btrees."

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
