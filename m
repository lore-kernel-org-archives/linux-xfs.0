Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 131DB7F69
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 08:26:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7E428F8037
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 06:25:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lzM8HXqFQ7KbJR0z for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 06:25:59 -0800 (PST)
Message-ID: <513751F2.2060109@redhat.com>
Date: Wed, 06 Mar 2013 09:25:54 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
In-Reply-To: <CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
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
To: Supratik Goswami <supratik.goswami@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, xfs@oss.sgi.com, Vivek Goel <vivek.goel@webyog.com>, Shrinath M <shrinath.m@webyog.com>

I would suggest contacting Amazon's customer support channel (or the vendor you 
paid for the Linux instance you are running).

XFS developer list is probably not the correct forum to help you debug this :)

Good luck!

Ric


On 03/06/2013 08:12 AM, Supratik Goswami wrote:
> Have we created a ticket with AWS ?
>
> It could be an EBS issue who knows, we need to confirm that first.
>
> --
> Warm Regards
>
> Supratik
>
>
> On Wed, Mar 6, 2013 at 6:38 PM, Ric Wheeler <rwheeler@redhat.com 
> <mailto:rwheeler@redhat.com>> wrote:
>
>     On 03/06/2013 08:03 AM, Shrinath M wrote:
>
>
>         On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler <rwheeler@redhat.com
>         <mailto:rwheeler@redhat.com> <mailto:rwheeler@redhat.com
>         <mailto:rwheeler@redhat.com>>> wrote:
>
>             I think that you would need to verify that the Amazon storage is not
>             throwing errors - do your logs show IO errors or issues before XFS
>         hits an
>             issue?
>
>
>         No IO errors in /var/log/messages.
>         Where else should I be looking?
>
>
>
>     Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (md0): I/O
>     Error Detected. Shutting down filesystem
>
>     Is an IO error from MD.
>
>     I would suggest trying to reproduce without MD in the picture first -
>     always best to try to reproduce with the simplest setup first and work
>     your way up the complexity ladder,
>
>     Ric
>
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
