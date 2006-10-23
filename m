Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Oct 2006 03:07:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9NA7gaG014943
	for <linux-xfs@oss.sgi.com>; Mon, 23 Oct 2006 03:07:43 -0700
Received: from smtp103.sbc.mail.mud.yahoo.com (smtp103.sbc.mail.mud.yahoo.com [68.142.198.202])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0DBD7D1A23CD
	for <linux-xfs@oss.sgi.com>; Mon, 23 Oct 2006 02:02:22 -0700 (PDT)
Date: Mon, 23 Oct 2006 02:02:19 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: your mail
Message-ID: <20061023090219.GA18714@tuatara.stupidest.org>
References: <D3E576A1A7C7134694A0DDA7C2CA4B884C3985@hyd-mail2.bbnet.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3E576A1A7C7134694A0DDA7C2CA4B884C3985@hyd-mail2.bbnet.ad>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chakka Satish Kumar <ChakkaSatish.Kumar@conexant.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Oct 23, 2006 at 12:47:20PM +0530, Chakka Satish Kumar wrote:

> I formatted a partition of size 5GB with xfs block size=16K

you can't use a block size large than your machines page size, so you
probably want to leave it at 4K (the default in most cases)
