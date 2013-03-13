Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E29927F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 14:11:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A67B0304051
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 12:11:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ul5IRK2JD1vzPyNA for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 12:10:59 -0700 (PDT)
Message-ID: <5140CF42.6000206@sandeen.net>
Date: Wed, 13 Mar 2013 14:10:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
	<5140CBE3.80705@sandeen.net>
In-Reply-To: <5140CBE3.80705@sandeen.net>
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
To: Shrinath M <shrinath.m@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, xfs@oss.sgi.com, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>, Vivek Goel <vivek.goel@webyog.com>

On 3/13/13 1:56 PM, Eric Sandeen wrote:

> It's a little odd that you get:
> 
> Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.014259] XFS (md0): xfs_iunlink_remove: xfs_itobp() returned error 117.
> 
> because AFAIK, 117 is not any known error number (not even xfs's old EFSCORRUPTED value, which was 990)
> But I see other references in various places to this error number coming from XFS - so I'm not sure.

Ugh, no it's not odd, it's:

#define EUCLEAN 117
which maps to EFSCORRUPTED.  Sorry for that noise, how'd I miss that?  :(

Anyway, turn up the error level & see if you get more info.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
