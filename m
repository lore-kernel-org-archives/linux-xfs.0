Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 12:15:09 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77JEcDW032413
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 12:14:48 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k77JE1nx020038
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 14:14:01 -0500
Message-ID: <44D790E2.8030000@sgi.com>
Date: Mon, 07 Aug 2006 14:13:38 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com> <20060807150324.GA8421@kickball-mn.Central.Sun.COM> <44D75C87.8050402@thebarn.com> <20060807155248.GA22411@tuatara.stupidest.org> <20060807165159.GA10521@kickball-mn.Central.Sun.COM>
In-Reply-To: <20060807165159.GA10521@kickball-mn.Central.Sun.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dean Roehrich <dean.roehrich@sun.com>
Cc: Chris Wedgwood <cw@f00f.org>, Russell Cattelan <cattelan@thebarn.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

On 08/07/06 11:51, Dean Roehrich wrote:
> On Mon, Aug 07, 2006 at 08:52:48AM -0700, Chris Wedgwood wrote:
>> On Mon, Aug 07, 2006 at 10:30:15AM -0500, Russell Cattelan wrote:
>>
>>> It seems rather dangerous to have a #define floating around that
>>> could potentially get out of sync with the original, especially if
>>> you transport the number and not the enum table. (It make it really
>>> hard for cscope to find :-)
>> If it saves a header I don't see any harm in the original approach
>> with a comment preceding it explain what the bits are and why not to
>> screw them up.
> 
> I agree with Russell that you want cscope to tell you about every place those
> bits are being used, so you want those defines or at least those symbols to
> show up here.  Having them in a comment won't help cscope.
> 
> Dean

I'll put these defines in hsmapi.c, and revert DMF_EV_BITS back to using
these symbols:

/* DM_EVENT_* are defined in <xfs/dmapi.h>. Trying to avoid a dmapi dependency
  * in xfsdump since dmapi is not commonly used, yet this code needs to know some
  * of the event bits.
  */
#define	DM_EVENT_READ		16
#define	DM_EVENT_WRITE		17
#define	DM_EVENT_TRUNCATE	18
#define	DM_EVENT_DESTROY	20

Bill
