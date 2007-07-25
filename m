Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jul 2007 03:33:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6PAXFbm006510
	for <xfs@oss.sgi.com>; Wed, 25 Jul 2007 03:33:17 -0700
Message-ID: <46A7226D.8080906@sgi.com>
Date: Wed, 25 Jul 2007 20:14:05 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com>
In-Reply-To: <20070725092445.GT12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



David Chinner wrote:
> 
> The next question is the hard one. What do we do when we detect
> a log record CRC error? Right now it just warns and sets a flag
> in the log. I think it should probably prevent log replay from
> replaying past this point (i.e. trim the head back to the last
> good log record) but I'm not sure what the best thing to do here.
> 
> Comments?

1. perhaps use a new flag XLOG_CRC_MISMATCH instead of XLOG_CHKSUM_MISMATCH
2. is there (or could there be if we added it), correction for n-bit errors?

-- Mark
